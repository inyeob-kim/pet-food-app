from sqlalchemy import Column, String, Index, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid

from app.db.base import Base, TimestampMixin


class User(Base, TimestampMixin):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String(255), nullable=True, index=True)
    provider = Column(String(50), nullable=False)  # 예: 'email', 'google', 'kakao'
    provider_user_id = Column(String(255), nullable=False)
    timezone = Column(String(50), default='Asia/Seoul', nullable=False)

    __table_args__ = (
        UniqueConstraint('provider', 'provider_user_id', name='uq_user_provider'),
        Index('ix_users_email', 'email'),
    )

    # Relationships
    pets = relationship("Pet", back_populates="user", cascade="all, delete-orphan")
    trackings = relationship("Tracking", back_populates="user", cascade="all, delete-orphan")
