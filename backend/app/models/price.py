from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Index
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
import uuid

from app.db.base import Base, TimestampMixin


class PriceSnapshot(Base, TimestampMixin):
    __tablename__ = "price_snapshots"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    offer_id = Column(UUID(as_uuid=True), ForeignKey("product_offers.id"), nullable=False, index=True)
    price = Column(Integer, nullable=False)  # 가격 (원)
    currency = Column(String(3), default='KRW', nullable=False)
    captured_at = Column(DateTime(timezone=True), nullable=False)
    meta = Column(JSONB, nullable=True)  # 추가 메타데이터

    __table_args__ = (
        Index('ix_price_snapshots_offer_captured', 'offer_id', 'captured_at', postgresql_ops={'captured_at': 'DESC'}),
    )

    # Relationships
    offer = relationship("ProductOffer", back_populates="price_snapshots")


class PriceSummary(Base, TimestampMixin):
    __tablename__ = "price_summaries"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    offer_id = Column(UUID(as_uuid=True), ForeignKey("product_offers.id"), nullable=False, unique=True)
    window_days = Column(Integer, default=14, nullable=False)
    avg_price = Column(Integer, nullable=False)
    min_price = Column(Integer, nullable=False)
    max_price = Column(Integer, nullable=False)
    last_price = Column(Integer, nullable=False)
    last_captured_at = Column(DateTime(timezone=True), nullable=False)

    # Relationships
    offer = relationship("ProductOffer", back_populates="price_summary")
