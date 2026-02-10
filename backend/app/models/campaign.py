from sqlalchemy import Column, String, Boolean, ForeignKey, Integer, DateTime, Text, Index, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import uuid
import enum

from app.db.base import Base, TimestampMixin


class CampaignKind(str, enum.Enum):
    EVENT = "EVENT"
    NOTICE = "NOTICE"
    AD = "AD"


class CampaignPlacement(str, enum.Enum):
    HOME_MODAL = "HOME_MODAL"
    HOME_BANNER = "HOME_BANNER"
    NOTICE_CENTER = "NOTICE_CENTER"


class CampaignTemplate(str, enum.Enum):
    IMAGE_TOP = "image_top"
    NO_IMAGE = "no_image"
    PRODUCT_SPOTLIGHT = "product_spotlight"


class Campaign(Base, TimestampMixin):
    """이벤트/공지/광고 통합 테이블"""
    __tablename__ = "campaigns"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    key = Column(Text, nullable=False, unique=True)  # e.g. 'first_tracking_1000p'
    kind = Column(String(20), nullable=False)  # EVENT | NOTICE | AD
    placement = Column(String(30), nullable=False)  # HOME_MODAL | HOME_BANNER | NOTICE_CENTER
    template = Column(String(30), nullable=False)  # image_top | no_image | product_spotlight
    priority = Column(Integer, nullable=False, server_default='100')
    is_enabled = Column(Boolean, nullable=False, server_default='true')

    start_at = Column(DateTime(timezone=True), nullable=False)
    end_at = Column(DateTime(timezone=True), nullable=False)

    content = Column(JSONB, nullable=False, server_default='{}')  # JSONB: 제목, 본문, 이미지 URL 등

    __table_args__ = (
        Index('idx_campaigns_active', 'is_enabled', 'start_at', 'end_at', 'priority'),
    )

    # Relationships
    rules = relationship("CampaignRule", back_populates="campaign", cascade="all, delete-orphan")
    actions = relationship("CampaignAction", back_populates="campaign", cascade="all, delete-orphan")
    impressions = relationship("UserCampaignImpression", back_populates="campaign", cascade="all, delete-orphan")
    rewards = relationship("UserCampaignReward", back_populates="campaign", cascade="all, delete-orphan")


class CampaignRule(Base):
    """노출/지급 대상 조건 규칙 (JSON Rule Engine)"""
    __tablename__ = "campaign_rules"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    campaign_id = Column(UUID(as_uuid=True), ForeignKey("campaigns.id", ondelete="CASCADE"), nullable=False)
    rule = Column(JSONB, nullable=False)  # JSONB: 조건 규칙

    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    __table_args__ = (
        Index('idx_campaign_rules_campaign', 'campaign_id'),
        Index('idx_campaign_rules_gin', 'rule', postgresql_using='gin'),
    )

    # Relationships
    campaign = relationship("Campaign", back_populates="rules")


class CampaignTrigger(str, enum.Enum):
    FIRST_TRACKING_CREATED = "FIRST_TRACKING_CREATED"
    ALERT_CLICKED = "ALERT_CLICKED"
    REFERRAL_CONFIRMED = "REFERRAL_CONFIRMED"


class CampaignActionType(str, enum.Enum):
    GRANT_POINTS = "GRANT_POINTS"
    SHOW_ONLY = "SHOW_ONLY"


class CampaignAction(Base):
    """트리거 + 액션 (이벤트 로직 핵심)"""
    __tablename__ = "campaign_actions"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    campaign_id = Column(UUID(as_uuid=True), ForeignKey("campaigns.id", ondelete="CASCADE"), nullable=False)

    trigger = Column(String(50), nullable=False)  # FIRST_TRACKING_CREATED | ALERT_CLICKED | REFERRAL_CONFIRMED
    action_type = Column(String(30), nullable=False)  # GRANT_POINTS | SHOW_ONLY
    action = Column(JSONB, nullable=False)  # JSONB: { "points": 1000 } 등

    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    __table_args__ = (
        Index('idx_campaign_actions_campaign', 'campaign_id'),
        Index('idx_campaign_actions_trigger', 'trigger'),
    )

    # Relationships
    campaign = relationship("Campaign", back_populates="actions")
    rewards = relationship("UserCampaignReward", back_populates="action", cascade="all, delete-orphan")


class UserCampaignImpression(Base):
    """유저별 이벤트 노출 기록 (중복 노출 방지)"""
    __tablename__ = "user_campaign_impressions"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    campaign_id = Column(UUID(as_uuid=True), ForeignKey("campaigns.id", ondelete="CASCADE"), nullable=False)

    first_seen_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    last_seen_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    seen_count = Column(Integer, nullable=False, server_default='1')
    suppress_until = Column(DateTime(timezone=True), nullable=True)

    __table_args__ = (
        UniqueConstraint('user_id', 'campaign_id', name='uq_user_campaign_impression'),
        Index('idx_user_campaign_impressions_user', 'user_id'),
    )

    # Relationships
    campaign = relationship("Campaign", back_populates="impressions")


class RewardStatus(str, enum.Enum):
    GRANTED = "GRANTED"
    FAILED = "FAILED"
    PENDING = "PENDING"


class UserCampaignReward(Base):
    """이벤트 보상 지급 (중복 지급 차단 핵심)"""
    __tablename__ = "user_campaign_rewards"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    campaign_id = Column(UUID(as_uuid=True), ForeignKey("campaigns.id", ondelete="CASCADE"), nullable=False)
    action_id = Column(UUID(as_uuid=True), ForeignKey("campaign_actions.id", ondelete="CASCADE"), nullable=False)

    status = Column(String(20), nullable=False)  # GRANTED | FAILED | PENDING
    granted_at = Column(DateTime(timezone=True), nullable=True)
    idempotency_key = Column(Text, nullable=True)  # 중복 지급 방지용

    __table_args__ = (
        UniqueConstraint('user_id', 'campaign_id', 'action_id', name='uq_user_campaign_reward'),
        Index('idx_user_campaign_rewards_user', 'user_id'),
    )

    # Relationships
    campaign = relationship("Campaign", back_populates="rewards")
    action = relationship("CampaignAction", back_populates="rewards")
