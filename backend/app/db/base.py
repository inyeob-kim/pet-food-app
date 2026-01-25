from sqlalchemy.orm import DeclarativeBase
from sqlalchemy import Column, DateTime, func
from sqlalchemy.dialects.postgresql import UUID
import uuid


class Base(DeclarativeBase):
    """SQLAlchemy 2.0 Base class"""
    pass


class TimestampMixin:
    """created_at, updated_at 자동 관리 Mixin"""
    created_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )
    updated_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )

