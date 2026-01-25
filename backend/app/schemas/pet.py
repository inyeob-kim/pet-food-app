from pydantic import BaseModel, Field
from typing import Optional
from uuid import UUID
from datetime import datetime

from app.models.pet import AgeStage


class PetCreate(BaseModel):
    """반려동물 생성 요청"""
    name: Optional[str] = None
    breed_code: str = Field(..., description="견종 코드")
    weight_bucket_code: str = Field(..., description="체중 구간 코드 (예: '5-10kg')")
    age_stage: AgeStage = Field(..., description="나이 단계")
    is_neutered: Optional[bool] = Field(None, description="중성화 여부")
    is_primary: Optional[bool] = Field(False, description="주 반려동물 여부")


class PetRead(BaseModel):
    """반려동물 조회 응답"""
    id: UUID
    user_id: UUID
    name: Optional[str] = None
    breed_code: str
    weight_bucket_code: str
    age_stage: AgeStage
    is_neutered: Optional[bool] = None
    is_primary: bool
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}

