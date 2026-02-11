"""사용자 추천 선호도 모델"""
from sqlalchemy import Column, ForeignKey, String, Index
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
import uuid

from app.db.base import Base, TimestampMixin


class UserRecoPrefs(Base, TimestampMixin):
    """사용자별 추천 선호도 설정"""
    __tablename__ = "user_reco_prefs"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, unique=True)
    
    # 선호도 설정 (JSONB)
    # weights_preset: "SAFE" | "BALANCED" | "VALUE"
    # hard_exclude_allergens: List[str]  # 사용자가 추가로 제외할 알레르겐
    # soft_avoid_ingredients: List[str]  # 피하고 싶은 성분 (페널티만)
    # max_price_per_kg: Optional[int]  # 최대 가격 제한 (원/kg)
    # sort_preference: "default" | "price_asc"  # 정렬 선호도
    # health_concern_priority: bool  # 건강 고민 우선 모드
    prefs = Column(JSONB, nullable=False, server_default='{}')

    __table_args__ = (
        Index('idx_user_reco_prefs_user', 'user_id'),
    )

    # Relationships
    user = relationship("User", backref="reco_prefs")
