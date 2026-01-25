from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from uuid import UUID

from app.db.session import get_db
from app.schemas.tracking import TrackingCreate, TrackingRead
from app.models.tracking import Tracking, TrackingStatus


router = APIRouter()


@router.get("/", response_model=list[TrackingRead])
async def get_trackings(db: AsyncSession = Depends(get_db)):
    """가격 추적 목록 조회"""
    # TODO: 실제 user_id 기반 필터링 구현
    result = await db.execute(
        select(Tracking).where(Tracking.status != TrackingStatus.DELETED)
    )
    trackings = result.scalars().all()
    return [TrackingRead.model_validate(t) for t in trackings]


@router.post("/", response_model=TrackingRead, status_code=status.HTTP_201_CREATED)
async def create_tracking(
    tracking_data: TrackingCreate,
    db: AsyncSession = Depends(get_db)
):
    """가격 추적 시작"""
    # TODO: 실제 user_id 설정 및 중복 체크 구현
    tracking = Tracking(
        user_id=UUID("00000000-0000-0000-0000-000000000000"),  # Mock user_id
        pet_id=tracking_data.pet_id,
        product_id=tracking_data.product_id,
        status=TrackingStatus.ACTIVE,
    )
    db.add(tracking)
    await db.commit()
    await db.refresh(tracking)
    return TrackingRead.model_validate(tracking)


@router.get("/{tracking_id}", response_model=TrackingRead)
async def get_tracking(tracking_id: UUID, db: AsyncSession = Depends(get_db)):
    """가격 추적 상세 조회"""
    result = await db.execute(select(Tracking).where(Tracking.id == tracking_id))
    tracking = result.scalar_one_or_none()
    
    if tracking is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tracking not found"
        )
    
    return TrackingRead.model_validate(tracking)


@router.delete("/{tracking_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_tracking(tracking_id: UUID, db: AsyncSession = Depends(get_db)):
    """가격 추적 중지"""
    result = await db.execute(select(Tracking).where(Tracking.id == tracking_id))
    tracking = result.scalar_one_or_none()
    
    if tracking is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tracking not found"
        )
    
    tracking.status = TrackingStatus.DELETED
    await db.commit()
    return None
