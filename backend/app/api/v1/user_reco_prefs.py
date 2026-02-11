"""사용자 추천 선호도 API 라우터"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID

from app.db.session import get_db
from app.schemas.user_reco_prefs import UserRecoPrefsRead, UserRecoPrefsCreate, UserRecoPrefsUpdate
from app.services.user_reco_prefs_service import UserRecoPrefsService

router = APIRouter()


@router.get("/me", response_model=UserRecoPrefsRead)
async def get_my_prefs(
    user_id: UUID,  # TODO: 실제 인증에서 가져오기
    db: AsyncSession = Depends(get_db)
):
    """내 추천 선호도 조회"""
    prefs = await UserRecoPrefsService.get_user_prefs(user_id, db)
    if not prefs:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User preferences not found"
        )
    return prefs


@router.post("/me", response_model=UserRecoPrefsRead)
async def create_my_prefs(
    user_id: UUID,  # TODO: 실제 인증에서 가져오기
    prefs_data: UserRecoPrefsCreate,
    db: AsyncSession = Depends(get_db)
):
    """내 추천 선호도 생성"""
    prefs = await UserRecoPrefsService.create_or_update_user_prefs(
        user_id, prefs_data, db
    )
    return prefs


@router.put("/me", response_model=UserRecoPrefsRead)
async def update_my_prefs(
    user_id: UUID,  # TODO: 실제 인증에서 가져오기
    prefs_data: UserRecoPrefsUpdate,
    db: AsyncSession = Depends(get_db)
):
    """내 추천 선호도 업데이트 (부분 업데이트 가능)"""
    prefs = await UserRecoPrefsService.create_or_update_user_prefs(
        user_id, prefs_data, db
    )
    return prefs


@router.delete("/me")
async def delete_my_prefs(
    user_id: UUID,  # TODO: 실제 인증에서 가져오기
    db: AsyncSession = Depends(get_db)
):
    """내 추천 선호도 삭제"""
    deleted = await UserRecoPrefsService.delete_user_prefs(user_id, db)
    if not deleted:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User preferences not found"
        )
    return {"message": "User preferences deleted"}
