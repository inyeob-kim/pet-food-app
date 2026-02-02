"""클릭 추적 API 라우터 - 라우팅만 담당"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID

from app.db.session import get_db
from app.schemas.click import ClickCreate, ClickRead
from app.services.click_service import ClickService

router = APIRouter()


@router.post("/", response_model=ClickRead, status_code=status.HTTP_201_CREATED)
async def create_click(
    click_data: ClickCreate,
    db: AsyncSession = Depends(get_db),
    # TODO: 실제 인증 구현 후 user: User = Depends(get_current_user)
):
    """클릭 이벤트 생성"""
    # TODO: 실제 user_id 설정 구현
    mock_user_id = UUID("00000000-0000-0000-0000-000000000000")
    click = await ClickService.create_click(mock_user_id, click_data, db)
    return ClickRead.model_validate(click)

