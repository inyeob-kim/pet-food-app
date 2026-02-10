from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Text, Index
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import uuid

from app.db.base import Base, TimestampMixin


class PointWallet(Base):
    """포인트 지갑 - 빠른 조회용 잔액"""
    __tablename__ = "point_wallets"

    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    balance = Column(Integer, nullable=False, server_default='0')
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)


class PointLedger(Base):
    """포인트 장부 - 모든 적립/차감 이력"""
    __tablename__ = "point_ledger"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    delta = Column(Integer, nullable=False)  # +1000 / -500
    reason = Column(Text, nullable=False)  # campaign:first_tracking_1000p
    ref_type = Column(String(50), nullable=True)  # campaign_reward
    ref_id = Column(UUID(as_uuid=True), nullable=True)  # 참조 ID
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    __table_args__ = (
        Index('idx_point_ledger_user', 'user_id'),
    )
