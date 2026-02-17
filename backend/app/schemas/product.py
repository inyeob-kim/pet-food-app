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
    technical_explanation: Optional[str] = Field(None, description="추천 과정 설명 (기술적 이유 기반, 빠름)")
    expert_explanation: Optional[str] = Field(None, description="전문가 수준 설명 (RAG 문서 기반, 느림)")
    # Deprecated: 하위 호환성을 위해 유지 (expert_explanation과 동일)
    explanation: Optional[str] = Field(None, description="[Deprecated] expert_explanation과 동일")
    # 애니메이션용 상세 분석 데이터
    ingredient_count: Optional[int] = Field(None, description="검출된 성분 개수")
    main_ingredients: Optional[List[str]] = Field(None, description="주요 성분 리스트")
    allergy_ingredients: Optional[List[str]] = Field(None, description="알레르기 성분 리스트")
    harmful_ingredients: Optional[List[str]] = Field(None, description="유해 성분 리스트")
    quality_checklist: Optional[List[str]] = Field(None, description="품질 체크리스트")
    daily_amount_g: Optional[float] = Field(None, description="하루 권장 급여량 (g)")
    # v1.1.0 추가 필드
    animation_explanation: Optional[str] = Field(None, description="Step 1~5에 들어갈 짧은 한 줄 설명 (e.g. '닭고기 ZERO, 단일단백질')")
    safety_badges: Optional[List[str]] = Field(None, description="안전성 배지 리스트 (e.g. ['알레르기 안전', '유해성분 없음'])")
    confidence_score: Optional[float] = Field(None, description="RAG 신뢰도 (0~100)")


class RecommendationResponse(BaseModel):
    """추천 상품 목록 응답"""
    pet_id: UUID
    items: List[RecommendationItem]
    is_cached: bool = Field(default=False, description="캐싱된 추천 여부")
    last_recommended_at: Optional[datetime] = Field(default=None, description="마지막 추천 시각")
    message: Optional[str] = Field(default=None, description="추천 결과가 없을 때 사용자 친화적 메시지")


class ProductMatchScoreResponse(BaseModel):
    """특정 상품의 맞춤 점수 응답"""
    product_id: UUID
    pet_id: UUID
    match_score: float = Field(..., description="총점 (0~100)")
    safety_score: float = Field(..., description="안전성 점수 (0~100)")
    fitness_score: float = Field(..., description="적합성 점수 (0~100)")
    match_reasons: List[str] = Field(default_factory=list, description="매칭 이유 리스트")
    score_components: dict = Field(default_factory=dict, description="세부 점수 분해")
    calculated_at: datetime = Field(default_factory=datetime.now, description="점수 계산 시각")


class OfferDetailRead(BaseModel):
    """판매처 상세 정보"""
    id: UUID
    merchant: str
    url: str
    affiliate_url: Optional[str] = None
    current_price: Optional[int] = None
    is_primary: bool
    is_active: bool

    model_config = {"from_attributes": True}


class IngredientDetailRead(BaseModel):
    """성분 상세 정보 (일반 사용자용)"""
    main_ingredients: Optional[List[str]] = None
    allergens: Optional[List[str]] = None
    description: Optional[str] = None

    model_config = {"from_attributes": True}


class NutritionDetailRead(BaseModel):
    """영양 정보 상세 (일반 사용자용)"""
    protein_pct: Optional[float] = None
    fat_pct: Optional[float] = None
    fiber_pct: Optional[float] = None
    moisture_pct: Optional[float] = None
    calcium_pct: Optional[float] = None
    phosphorus_pct: Optional[float] = None
    kcal_per_100g: Optional[int] = None

    model_config = {"from_attributes": True}


class ClaimDetailRead(BaseModel):
    """기능성 클레임 상세 (일반 사용자용)"""
    claim_code: str
    claim_display_name: Optional[str] = None
    evidence_level: int
    note: Optional[str] = None

    model_config = {"from_attributes": True}


class PriceHistoryRead(BaseModel):
    """가격 히스토리"""
    date: datetime
    price: int

    model_config = {"from_attributes": True}


class ProductDetailResponse(BaseModel):
    """제품 상세 정보 응답 (일반 사용자용)"""
    product: ProductRead
    offers: List[OfferDetailRead] = Field(default_factory=list)
    current_price: Optional[int] = None
    average_price: Optional[int] = None
    min_price: Optional[int] = None
    max_price: Optional[int] = None
    purchase_url: Optional[str] = None
    price_history: List[PriceHistoryRead] = Field(default_factory=list)
    ingredient: Optional[IngredientDetailRead] = None
    nutrition: Optional[NutritionDetailRead] = None
    claims: List[ClaimDetailRead] = Field(default_factory=list)

