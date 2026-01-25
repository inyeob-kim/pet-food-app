from pydantic import BaseModel, Field
from typing import Optional
from uuid import UUID
from datetime import datetime

from app.models.alert import AlertRuleType


class AlertCreate(BaseModel):
    """알림 생성 요청"""
    tracking_id: UUID
    rule_type: AlertRuleType
    target_price: Optional[int] = Field(None, description="목표 가격 (rule_type이 TARGET_PRICE일 때 필수)")
    cooldown_hours: Optional[int] = Field(24, description="쿨다운 시간 (시간)")


class AlertRead(BaseModel):
    """알림 조회 응답"""
    id: UUID
    tracking_id: UUID
    rule_type: AlertRuleType
    target_price: Optional[int] = None
    cooldown_hours: int
    is_enabled: bool
    last_triggered_at: Optional[datetime] = None

    model_config = {"from_attributes": True}

