from pydantic import BaseModel, Field
from typing import Optional, List
from uuid import UUID
from datetime import datetime

from app.models.offer import Merchant
from app.models.product import PetSpecies


class ProductRead(BaseModel):
    """상품 조회 응답"""
    id: UUID
    brand_name: str
    product_name: str
    size_label: Optional[str] = None
    is_active: bool
    category: Optional[str] = None
    species: Optional[PetSpecies] = None

    model_config = {"from_attributes": True}


class ProductCreate(BaseModel):
    """상품 생성 요청"""
    brand_name: str = Field(..., min_length=1, max_length=100)
    product_name: str = Field(..., min_length=1, max_length=255)
    size_label: Optional[str] = Field(None, max_length=50)
    category: str = Field(default="FOOD", max_length=30)
    species: Optional[PetSpecies] = None
    is_active: bool = Field(default=True)


class ProductUpdate(BaseModel):
    """상품 수정 요청"""
    brand_name: Optional[str] = Field(None, min_length=1, max_length=100)
    product_name: Optional[str] = Field(None, min_length=1, max_length=255)
    size_label: Optional[str] = Field(None, max_length=50)
    category: Optional[str] = Field(None, max_length=30)
    species: Optional[PetSpecies] = None
    is_active: Optional[bool] = None


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
    match_score: float = Field(..., description="총점")
    safety_score: float = Field(..., description="안전성 점수")
    fitness_score: float = Field(..., description="적합성 점수")
    match_reasons: Optional[List[str]] = Field(None, description="추천 이유 리스트 (기술적)")
    explanation: Optional[str] = Field(None, description="추천 이유 자연어 설명")
    # 애니메이션용 상세 분석 데이터
    ingredient_count: Optional[int] = Field(None, description="검출된 성분 개수")
    main_ingredients: Optional[List[str]] = Field(None, description="주요 성분 리스트")
    allergy_ingredients: Optional[List[str]] = Field(None, description="알레르기 성분 리스트")
    harmful_ingredients: Optional[List[str]] = Field(None, description="유해 성분 리스트")
    quality_checklist: Optional[List[str]] = Field(None, description="품질 체크리스트")
    daily_amount_g: Optional[float] = Field(None, description="하루 권장 급여량 (g)")


class RecommendationResponse(BaseModel):
    """추천 상품 목록 응답"""
    pet_id: UUID
    items: List[RecommendationItem]
    is_cached: bool = Field(default=False, description="캐싱된 추천 여부")
    last_recommended_at: Optional[datetime] = Field(default=None, description="마지막 추천 시각")
    message: Optional[str] = Field(default=None, description="추천 결과가 없을 때 사용자 친화적 메시지")

