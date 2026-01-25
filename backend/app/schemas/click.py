from pydantic import BaseModel, Field
from typing import Optional
from uuid import UUID
from datetime import datetime

from app.models.outbound_click import ClickSource


class ClickCreate(BaseModel):
    """클릭 이벤트 생성 요청"""
    pet_id: Optional[UUID] = None
    product_id: UUID
    offer_id: UUID
    source: ClickSource


class ClickRead(BaseModel):
    """클릭 이벤트 조회 응답"""
    id: UUID
    clicked_at: datetime

    model_config = {"from_attributes": True}

