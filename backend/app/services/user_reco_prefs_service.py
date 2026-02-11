"""사용자 추천 선호도 서비스"""
from typing import Optional
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from fastapi import HTTPException, status
import logging

from app.models.user_reco_prefs import UserRecoPrefs
from app.schemas.user_reco_prefs import UserRecoPrefsCreate, UserRecoPrefsUpdate

logger = logging.getLogger(__name__)


class UserRecoPrefsService:
    """사용자 추천 선호도 서비스"""
    
    @staticmethod
    async def get_user_prefs(
        user_id: UUID,
        db: AsyncSession
    ) -> Optional[UserRecoPrefs]:
        """사용자 선호도 조회"""
        result = await db.execute(
            select(UserRecoPrefs).where(UserRecoPrefs.user_id == user_id)
        )
        return result.scalars().first()
    
    @staticmethod
    async def create_or_update_user_prefs(
        user_id: UUID,
        prefs_data: UserRecoPrefsCreate | UserRecoPrefsUpdate,
        db: AsyncSession
    ) -> UserRecoPrefs:
        """사용자 선호도 생성 또는 업데이트"""
        # 기존 선호도 조회
        existing = await UserRecoPrefsService.get_user_prefs(user_id, db)
        
        if existing:
            # 업데이트
            prefs_dict = prefs_data.model_dump(exclude_unset=True)
            if prefs_dict:
                # 기존 prefs와 병합
                current_prefs = existing.prefs or {}
                current_prefs.update(prefs_dict)
                existing.prefs = current_prefs
                await db.commit()
                await db.refresh(existing)
                logger.info(f"[UserRecoPrefsService] 사용자 선호도 업데이트: user_id={user_id}")
                return existing
            return existing
        else:
            # 생성
            prefs_dict = prefs_data.model_dump()
            new_prefs = UserRecoPrefs(
                user_id=user_id,
                prefs=prefs_dict
            )
            db.add(new_prefs)
            await db.commit()
            await db.refresh(new_prefs)
            logger.info(f"[UserRecoPrefsService] 사용자 선호도 생성: user_id={user_id}")
            return new_prefs
    
    @staticmethod
    async def delete_user_prefs(
        user_id: UUID,
        db: AsyncSession
    ) -> bool:
        """사용자 선호도 삭제"""
        existing = await UserRecoPrefsService.get_user_prefs(user_id, db)
        if not existing:
            return False
        
        await db.delete(existing)
        await db.commit()
        logger.info(f"[UserRecoPrefsService] 사용자 선호도 삭제: user_id={user_id}")
        return True
