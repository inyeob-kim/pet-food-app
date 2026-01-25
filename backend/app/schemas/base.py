from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import Optional
from uuid import UUID


class BaseSchema(BaseModel):
    """Base schema with common configuration"""
    model_config = ConfigDict(
        from_attributes=True,  # SQLAlchemy ORM 모델에서 자동 변환
        # Pydantic v2에서 datetime과 UUID는 기본적으로 ISO8601 문자열과 문자열로 직렬화됨
        json_schema_extra={
            "example": {}
        }
    )


class TimestampSchema(BaseSchema):
    """created_at, updated_at 포함 스키마"""
    created_at: datetime
    updated_at: datetime

