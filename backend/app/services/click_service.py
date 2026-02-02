"""클릭 추적 관련 비즈니스 로직"""
from uuid import UUID
from datetime import datetime, timezone
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.outbound_click import OutboundClick
from app.schemas.click import ClickCreate


class ClickService:
    """클릭 추적 서비스 - 클릭 관련 비즈니스 로직만 담당"""
    
    @staticmethod
    async def create_click(
        user_id: UUID,
        click_data: ClickCreate,
        db: AsyncSession
    ) -> OutboundClick:
        """클릭 이벤트 생성"""
        click = OutboundClick(
            user_id=user_id,
            pet_id=click_data.pet_id,
            product_id=click_data.product_id,
            offer_id=click_data.offer_id,
            source=click_data.source,
            clicked_at=datetime.now(timezone.utc),
        )
        
        db.add(click)
        await db.commit()
        await db.refresh(click)
        
        return click
