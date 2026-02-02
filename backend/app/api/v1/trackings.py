"""가격 추적 API 라우터 - 라우팅만 담당"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID

from app.db.session import get_db
from app.schemas.tracking import TrackingCreate, TrackingRead
from app.services.tracking_service import TrackingService

router = APIRouter()


@router.get("/", response_model=list[TrackingRead])
async def get_trackings(
    db: AsyncSession = Depends(get_db),
    # TODO: 실제 인증 구현 후 user: User = Depends(get_current_user)
):
    """가격 추적 목록 조회"""
    # TODO: 실제 user_id 기반 필터링 구현
    mock_user_id = UUID("00000000-0000-0000-0000-000000000000")
    trackings = await TrackingService.get_trackings_by_user_id(mock_user_id, db)
    return [TrackingRead.model_validate(t) for t in trackings]


@router.post("/", response_model=TrackingRead, status_code=status.HTTP_201_CREATED)
async def create_tracking(
    tracking_data: TrackingCreate,
    db: AsyncSession = Depends(get_db),
    # TODO: 실제 인증 구현 후 user: User = Depends(get_current_user)
):
    """가격 추적 시작"""
    # TODO: 실제 user_id 설정 구현
    mock_user_id = UUID("00000000-0000-0000-0000-000000000000")
    tracking = await TrackingService.create_tracking(mock_user_id, tracking_data, db)
    return TrackingRead.model_validate(tracking)


@router.get("/{tracking_id}", response_model=TrackingRead)
async def get_tracking(
    tracking_id: UUID,
    db: AsyncSession = Depends(get_db)
):
    """가격 추적 상세 조회"""
    tracking = await TrackingService.get_tracking_by_id(tracking_id, db)
    return TrackingRead.model_validate(tracking)


@router.delete("/{tracking_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_tracking(
    tracking_id: UUID,
    db: AsyncSession = Depends(get_db)
):
    """가격 추적 중지"""
    await TrackingService.delete_tracking(tracking_id, db)
    return None
