from sqlalchemy import Column, String, Boolean, ForeignKey, Enum as SQLEnum, Index
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid
import enum

from app.db.base import Base, TimestampMixin


class AgeStage(str, enum.Enum):
    PUPPY = "PUPPY"
    ADULT = "ADULT"
    SENIOR = "SENIOR"


class Pet(Base, TimestampMixin):
    __tablename__ = "pets"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False, index=True)
    name = Column(String(100), nullable=True)
    breed_code = Column(String(50), nullable=False)
    weight_bucket_code = Column(String(20), nullable=False)  # 예: "5-10kg"
    age_stage = Column(SQLEnum(AgeStage), nullable=False)
    is_neutered = Column(Boolean, nullable=True)
    is_primary = Column(Boolean, default=False, nullable=False)

    __table_args__ = (
        Index('ix_pets_breed_weight_age', 'breed_code', 'weight_bucket_code', 'age_stage'),
    )

    # Relationships
    user = relationship("User", back_populates="pets")
    trackings = relationship("Tracking", back_populates="pet", cascade="all, delete-orphan")
