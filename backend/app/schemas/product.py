from pydantic import BaseModel, Field
from typing import Optional, List
from uuid import UUID
from datetime import datetime

from app.models.offer import Merchant


class ProductRead(BaseModel):
    """상품 조회 응답"""
    id: UUID
    brand_name: str
    product_name: str
    size_label: Optional[str] = None
    is_active: bool

    model_config = {"from_attributes": True}


class PriceSummaryRead(BaseModel):
    """가격 요약 조회 응답"""
    offer_id: UUID
    window_days: int
    avg_price: int
    min_price: int
    max_price: int
    last_price: int
    last_captured_at: datetime

    model_config = {"from_attributes": True}


class RecommendationItem(BaseModel):
    """추천 상품 아이템"""
    product: ProductRead
    offer_merchant: Merchant = Field(..., description="판매처")
    current_price: int = Field(..., description="현재 가격")
    avg_price: int = Field(..., description="평균 가격")
    delta_percent: Optional[float] = Field(None, description="평균 대비 변동률 (%)")
    is_new_low: bool = Field(..., description="최저가 여부")


class RecommendationResponse(BaseModel):
    """추천 상품 목록 응답"""
    pet_id: UUID
    items: List[RecommendationItem]

