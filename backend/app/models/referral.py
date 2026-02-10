from sqlalchemy import Column, String, ForeignKey, DateTime, Text, UniqueConstraint, Index
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import uuid
import enum

from app.db.base import Base, TimestampMixin


class ReferralStatus(str, enum.Enum):
    PENDING = "PENDING"
    CONFIRMED = "CONFIRMED"
    REWARDED = "REWARDED"


class ReferralCode(Base):
    """친구초대 코드"""
    __tablename__ = "referral_codes"

    inviter_user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    code = Column(Text, nullable=False, unique=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    # Relationships
    referrals = relationship("Referral", back_populates="referral_code", cascade="all, delete-orphan")


class Referral(Base):
    """리퍼럴 기록"""
    __tablename__ = "referrals"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    code = Column(Text, ForeignKey("referral_codes.code"), nullable=False)
    invitee_user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    invitee_device_id = Column(Text, nullable=True)  # 가입 전 device_uid
    status = Column(String(20), nullable=False)  # PENDING | CONFIRMED | REWARDED
    confirmed_at = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    __table_args__ = (
        UniqueConstraint('invitee_user_id', name='uq_referral_invitee_user'),
        Index('idx_referrals_code', 'code'),
        Index('idx_referrals_status', 'status'),
    )

    # Relationships
    referral_code = relationship("ReferralCode", back_populates="referrals")
