"""반려동물 API 라우터 - 라우팅만 담당"""
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID

from app.db.session import get_db
from app.schemas.pet import PetCreate, PetRead
from app.services.pet_service import PetService
from app.services.user_service import UserService

router = APIRouter()


@router.get("/", response_model=list[PetRead])
async def get_pets(
    db: AsyncSession = Depends(get_db),
    # TODO: 실제 인증 구현 후 user: User = Depends(get_current_user)
):
    """반려동물 목록 조회"""
    # TODO: 실제 user_id 기반 필터링 구현
    # 현재는 Mock user 사용
    mock_user_id = UUID("00000000-0000-0000-0000-000000000000")
    pets = await PetService.get_pets_by_user_id(mock_user_id, db)
    return [PetRead.model_validate(pet) for pet in pets]


@router.post("/", response_model=PetRead, status_code=201)
async def create_pet(
    pet_data: PetCreate,
    db: AsyncSession = Depends(get_db),
    # TODO: 실제 인증 구현 후 user: User = Depends(get_current_user)
):
    """반려동물 등록"""
    # TODO: 실제 user_id 설정 구현 (현재는 Mock user 사용)
    device_uid = "mock_device_uid"  # TODO: 실제 device_uid 추출
    mock_user = await UserService.get_or_create_user_by_device_uid(
        device_uid, "Mock User", db
    )
    
    pet = await PetService.create_pet(mock_user.id, pet_data, db)
    return PetRead.model_validate(pet)


@router.get("/{pet_id}", response_model=PetRead)
async def get_pet(
    pet_id: UUID,
    db: AsyncSession = Depends(get_db)
):
    """반려동물 상세 조회"""
    pet = await PetService.get_pet_by_id(pet_id, db)
    return PetRead.model_validate(pet)
