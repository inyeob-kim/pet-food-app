"""사용자 추천 선호도 스키마"""
from typing import Optional, List
from pydantic import BaseModel, Field
from uuid import UUID


class UserRecoPrefsBase(BaseModel):
    """사용자 추천 선호도 기본 스키마"""
    weights_preset: str = Field(
        default="BALANCED",
        description="가중치 프리셋: SAFE (안전 우선), BALANCED (균형), VALUE (가성비 우선)"
    )
    hard_exclude_allergens: List[str] = Field(
        default_factory=list,
        description="강제 제외할 알레르겐 코드 리스트"
    )
    soft_avoid_ingredients: List[str] = Field(
        default_factory=list,
        description="피하고 싶은 성분 리스트 (페널티만 적용)"
    )
    max_price_per_kg: Optional[int] = Field(
        default=None,
        description="최대 가격 제한 (원/kg)"
    )
    sort_preference: str = Field(
        default="default",
        description="정렬 선호도: default (기본), price_asc (가격 낮은 순)"
    )
    health_concern_priority: bool = Field(
        default=False,
        description="건강 고민 우선 모드 (건강 고민 매칭 가중치 1.5배)"
    )


class UserRecoPrefsCreate(UserRecoPrefsBase):
    """사용자 추천 선호도 생성 스키마"""
    pass


class UserRecoPrefsUpdate(BaseModel):
    """사용자 추천 선호도 업데이트 스키마 (부분 업데이트 가능)"""
    weights_preset: Optional[str] = None
    hard_exclude_allergens: Optional[List[str]] = None
    soft_avoid_ingredients: Optional[List[str]] = None
    max_price_per_kg: Optional[int] = None
    sort_preference: Optional[str] = None
    health_concern_priority: Optional[bool] = None


class UserRecoPrefsRead(UserRecoPrefsBase):
    """사용자 추천 선호도 조회 스키마"""
    id: UUID
    user_id: UUID
    
    class Config:
        from_attributes = True
