from sqlalchemy import Column, String, Boolean, Enum as SQLEnum
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
import uuid
import enum

from app.db.base import Base, TimestampMixin


class ProductCategory(str, enum.Enum):
    FOOD = "FOOD"


class Product(Base, TimestampMixin):
    __tablename__ = "products"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    category = Column(SQLEnum(ProductCategory), nullable=False)
    brand_name = Column(String(100), nullable=False)
    product_name = Column(String(255), nullable=False)
    size_label = Column(String(50), nullable=True)  # 예: "3kg", "5kg"
    internal_tags = Column(JSONB, nullable=True)  # JSON 배열
    is_active = Column(Boolean, default=True, nullable=False)

    # Relationships
    offers = relationship("ProductOffer", back_populates="product", cascade="all, delete-orphan")
    trackings = relationship("Tracking", back_populates="product", cascade="all, delete-orphan")
