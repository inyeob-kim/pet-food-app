"""Campaign 스키마 정의"""
from typing import Optional, List, Dict, Any
from datetime import datetime
from uuid import UUID
from pydantic import BaseModel, Field, field_validator

from app.models.campaign import CampaignKind, CampaignPlacement, CampaignTemplate, CampaignTrigger, CampaignActionType


# ========== Request/Response Base ==========
class CampaignRuleSchema(BaseModel):
    """Rule JSON 스키마"""
    all: List[Dict[str, Any]] = Field(default_factory=list, description="AND 조건 리스트")
    
    class Config:
        json_schema_extra = {
            "example": {
                "all": [
                    {"op": "eq", "key": "user.is_new", "value": True}
                ]
            }
        }


class CampaignActionSchema(BaseModel):
    """Action 스키마"""
    trigger: CampaignTrigger
    action_type: CampaignActionType
    action: Dict[str, Any] = Field(default_factory=dict, description="액션 데이터 (예: {'points': 1000})")
    
    @field_validator('action')
    @classmethod
    def validate_action(cls, v: Dict[str, Any], info) -> Dict[str, Any]:
        """GRANT_POINTS일 때 points 필수 검증"""
        if info.data.get('action_type') == CampaignActionType.GRANT_POINTS:
            if 'points' not in v or not isinstance(v.get('points'), int) or v.get('points') <= 0:
                raise ValueError("GRANT_POINTS일 때 action.points는 양수여야 합니다")
        return v


class CampaignContentSchema(BaseModel):
    """Content JSON 스키마"""
    title: str = ""
    description: str = ""
    image_url: Optional[str] = None
    cta: Optional[Dict[str, str]] = Field(default_factory=dict, description="{'text': '', 'deeplink': ''}")


# ========== Create ==========
class CampaignCreate(BaseModel):
    """캠페인 생성 요청"""
    key: str = Field(..., description="고유 키 (영문/숫자/언더스코어)")
    kind: CampaignKind
    placement: CampaignPlacement
    template: CampaignTemplate
    priority: int = Field(default=100, ge=0, description="작을수록 먼저")
    is_enabled: bool = Field(default=False, description="기본값 false (운영 실수 방지)")
    start_at: datetime
    end_at: datetime
    content: CampaignContentSchema
    rules: List[CampaignRuleSchema] = Field(default_factory=list, description="규칙 리스트")
    actions: List[CampaignActionSchema] = Field(default_factory=list, description="액션 리스트")
    
    @field_validator('end_at')
    @classmethod
    def validate_dates(cls, v: datetime, info) -> datetime:
        """start_at < end_at 검증"""
        if 'start_at' in info.data and v <= info.data['start_at']:
            raise ValueError("end_at은 start_at보다 이후여야 합니다")
        return v


# ========== Update ==========
class CampaignUpdate(BaseModel):
    """캠페인 수정 요청 (전체 교체 전략)"""
    key: Optional[str] = None
    kind: Optional[CampaignKind] = None
    placement: Optional[CampaignPlacement] = None
    template: Optional[CampaignTemplate] = None
    priority: Optional[int] = Field(None, ge=0)
    is_enabled: Optional[bool] = None
    start_at: Optional[datetime] = None
    end_at: Optional[datetime] = None
    content: Optional[CampaignContentSchema] = None
    rules: Optional[List[CampaignRuleSchema]] = None
    actions: Optional[List[CampaignActionSchema]] = None
    
    @field_validator('end_at')
    @classmethod
    def validate_dates(cls, v: Optional[datetime], info) -> Optional[datetime]:
        """start_at < end_at 검증"""
        start_at = info.data.get('start_at') or (v and info.data.get('start_at'))
        if v and start_at and v <= start_at:
            raise ValueError("end_at은 start_at보다 이후여야 합니다")
        return v


# ========== Read ==========
class CampaignRead(BaseModel):
    """캠페인 조회 응답"""
    id: UUID
    key: str
    kind: CampaignKind
    placement: CampaignPlacement
    template: CampaignTemplate
    priority: int
    is_enabled: bool
    start_at: datetime
    end_at: datetime
    content: Dict[str, Any]
    rules: List[Dict[str, Any]] = Field(default_factory=list)
    actions: List[Dict[str, Any]] = Field(default_factory=list)
    status: Optional[str] = Field(None, description="파생 상태: ACTIVE_NOW, SCHEDULED, EXPIRED, DISABLED")
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True


class CampaignToggleRequest(BaseModel):
    """캠페인 토글 요청"""
    is_enabled: bool


# ========== Simulate ==========
class CampaignSimulateRequest(BaseModel):
    """시뮬레이션 요청"""
    user_id: UUID
    trigger: CampaignTrigger
    context: Optional[Dict[str, Any]] = Field(default_factory=dict, description="pet_type, locale, app_version 등")


class CampaignSimulateResponse(BaseModel):
    """시뮬레이션 응답"""
    eligible_campaigns: List[Dict[str, Any]] = Field(default_factory=list)
    action: Optional[Dict[str, Any]] = None


# ========== Rewards/Impressions ==========
class RewardRead(BaseModel):
    """리워드 조회 응답"""
    id: UUID
    user_id: UUID
    campaign_id: UUID
    campaign_key: str
    status: str
    granted_at: Optional[datetime]
    idempotency_key: Optional[str]
    created_at: datetime
    
    class Config:
        from_attributes = True


class ImpressionRead(BaseModel):
    """노출 조회 응답"""
    id: UUID
    user_id: UUID
    campaign_id: UUID
    campaign_key: str
    seen_count: int
    suppress_until: Optional[datetime]
    last_seen_at: datetime
    first_seen_at: datetime
    
    class Config:
        from_attributes = True
