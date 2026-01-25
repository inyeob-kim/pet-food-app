from sqlalchemy import Column, String, DateTime, ForeignKey, Enum as SQLEnum, Index
from sqlalchemy.dialects.postgresql import UUID, JSONB
import uuid
import enum

from app.db.base import Base, TimestampMixin


class ClickSource(str, enum.Enum):
    HOME = "HOME"
    DETAIL = "DETAIL"
    ALERT = "ALERT"


class OutboundClick(Base, TimestampMixin):
    __tablename__ = "outbound_clicks"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False, index=True)
    pet_id = Column(UUID(as_uuid=True), ForeignKey("pets.id"), nullable=True)
    product_id = Column(UUID(as_uuid=True), ForeignKey("products.id"), nullable=False, index=True)
    offer_id = Column(UUID(as_uuid=True), ForeignKey("product_offers.id"), nullable=False)
    source = Column(SQLEnum(ClickSource), nullable=False)
    clicked_at = Column(DateTime(timezone=True), nullable=False)
    session_id = Column(String(255), nullable=True)
    meta = Column(JSONB, nullable=True)

    __table_args__ = (
        Index('ix_outbound_clicks_user_clicked', 'user_id', 'clicked_at', postgresql_ops={'clicked_at': 'DESC'}),
        Index('ix_outbound_clicks_product_clicked', 'product_id', 'clicked_at', postgresql_ops={'clicked_at': 'DESC'}),
    )

