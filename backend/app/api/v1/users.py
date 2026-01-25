from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.session import get_db

router = APIRouter()


@router.get("/")
async def get_users(db: AsyncSession = Depends(get_db)):
    """사용자 목록 조회"""
    return {"message": "Users endpoint"}


@router.get("/{user_id}")
async def get_user(user_id: str, db: AsyncSession = Depends(get_db)):
    """사용자 상세 조회"""
    return {"message": f"User {user_id}"}

