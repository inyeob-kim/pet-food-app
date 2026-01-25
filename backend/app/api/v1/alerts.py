from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from uuid import UUID

from app.db.session import get_db
from app.schemas.alert import AlertCreate, AlertRead
from app.models.alert import Alert


router = APIRouter()


@router.get("/", response_model=list[AlertRead])
async def get_alerts(db: AsyncSession = Depends(get_db)):
    """알림 목록 조회"""
    # TODO: 실제 user_id 기반 필터링 구현
    result = await db.execute(select(Alert).where(Alert.is_enabled == True))
    alerts = result.scalars().all()
    return [AlertRead.model_validate(a) for a in alerts]


@router.post("/", response_model=AlertRead, status_code=status.HTTP_201_CREATED)
async def create_alert(
    alert_data: AlertCreate,
    db: AsyncSession = Depends(get_db)
):
    """알림 생성"""
    # TODO: tracking_id 유효성 검증 구현
    alert = Alert(
        tracking_id=alert_data.tracking_id,
        rule_type=alert_data.rule_type,
        target_price=alert_data.target_price,
        cooldown_hours=alert_data.cooldown_hours or 24,
        is_enabled=True,
    )
    db.add(alert)
    await db.commit()
    await db.refresh(alert)
    return AlertRead.model_validate(alert)


@router.get("/{alert_id}", response_model=AlertRead)
async def get_alert(alert_id: UUID, db: AsyncSession = Depends(get_db)):
    """알림 상세 조회"""
    result = await db.execute(select(Alert).where(Alert.id == alert_id))
    alert = result.scalar_one_or_none()
    
    if alert is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Alert not found"
        )
    
    return AlertRead.model_validate(alert)


@router.patch("/{alert_id}/read", response_model=AlertRead)
async def mark_alert_read(alert_id: UUID, db: AsyncSession = Depends(get_db)):
    """알림 읽음 처리"""
    result = await db.execute(select(Alert).where(Alert.id == alert_id))
    alert = result.scalar_one_or_none()
    
    if alert is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Alert not found"
        )
    
    # TODO: 실제 읽음 처리 로직 구현 (alert_events 테이블 업데이트)
    return AlertRead.model_validate(alert)
