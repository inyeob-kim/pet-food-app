from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID

from app.db.session import get_db
from app.schemas.click import ClickCreate, ClickRead
from app.models.outbound_click import OutboundClick
from datetime import datetime, timezone


router = APIRouter()


@router.post("/", response_model=ClickRead, status_code=status.HTTP_201_CREATED)
async def create_click(
    click_data: ClickCreate,
    db: AsyncSession = Depends(get_db)
):
    """클릭 이벤트 생성"""
    # TODO: 실제 user_id 설정 구현
    click = OutboundClick(
        user_id=UUID("00000000-0000-0000-0000-000000000000"),  # Mock user_id
        pet_id=click_data.pet_id,
        product_id=click_data.product_id,
        offer_id=click_data.offer_id,
        source=click_data.source,
        clicked_at=datetime.now(timezone.utc),
    )
    db.add(click)
    await db.commit()
    await db.refresh(click)
    return ClickRead.model_validate(click)

