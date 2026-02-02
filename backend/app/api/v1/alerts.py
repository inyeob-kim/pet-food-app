"""알림 API 라우터 - 라우팅만 담당"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID

from app.db.session import get_db
from app.schemas.alert import AlertCreate, AlertRead
from app.services.alert_service import AlertService

router = APIRouter()


@router.get("/", response_model=list[AlertRead])
async def get_alerts(
    db: AsyncSession = Depends(get_db),
    # TODO: 실제 인증 구현 후 user: User = Depends(get_current_user)
):
    """알림 목록 조회"""
    # TODO: 실제 user_id 기반 필터링 구현
    mock_user_id = UUID("00000000-0000-0000-0000-000000000000")
    alerts = await AlertService.get_alerts_by_user_id(mock_user_id, db)
    return [AlertRead.model_validate(a) for a in alerts]


@router.post("/", response_model=AlertRead, status_code=status.HTTP_201_CREATED)
async def create_alert(
    alert_data: AlertCreate,
    db: AsyncSession = Depends(get_db)
):
    """알림 생성"""
    alert = await AlertService.create_alert(alert_data, db)
    return AlertRead.model_validate(alert)


@router.get("/{alert_id}", response_model=AlertRead)
async def get_alert(
    alert_id: UUID,
    db: AsyncSession = Depends(get_db)
):
    """알림 상세 조회"""
    alert = await AlertService.get_alert_by_id(alert_id, db)
    return AlertRead.model_validate(alert)


@router.patch("/{alert_id}/read", response_model=AlertRead)
async def mark_alert_read(
    alert_id: UUID,
    db: AsyncSession = Depends(get_db)
):
    """알림 읽음 처리"""
    alert = await AlertService.mark_alert_read(alert_id, db)
    return AlertRead.model_validate(alert)
