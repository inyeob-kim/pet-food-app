from pydantic import BaseModel
from uuid import UUID
from datetime import datetime

from app.models.tracking import TrackingStatus


class TrackingCreate(BaseModel):
    """가격 추적 생성 요청"""
    pet_id: UUID
    product_id: UUID


class TrackingRead(BaseModel):
    """가격 추적 조회 응답"""
    id: UUID
    pet_id: UUID
    product_id: UUID
    status: TrackingStatus
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}

