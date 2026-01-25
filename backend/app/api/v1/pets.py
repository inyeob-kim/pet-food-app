from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from uuid import UUID

from app.db.session import get_db
from app.schemas.pet import PetCreate, PetRead
from app.models.pet import Pet
from app.models.user import User


router = APIRouter()


@router.get("/", response_model=list[PetRead])
async def get_pets(db: AsyncSession = Depends(get_db)):
    """반려동물 목록 조회"""
    # TODO: 실제 user_id 기반 필터링 구현
    result = await db.execute(select(Pet))
    pets = result.scalars().all()
    return [PetRead.model_validate(pet) for pet in pets]


async def get_or_create_mock_user(db: AsyncSession) -> User:
    """Mock user를 가져오거나 생성"""
    mock_user_id = UUID("00000000-0000-0000-0000-000000000000")
    
    # 기존 user 조회
    result = await db.execute(select(User).where(User.id == mock_user_id))
    user = result.scalar_one_or_none()
    
    if user is None:
        # Mock user 생성
        user = User(
            id=mock_user_id,
            email=None,
            provider="mock",
            provider_user_id="mock_user",
            timezone="Asia/Seoul",
        )
        db.add(user)
        await db.commit()
        await db.refresh(user)
    
    return user


@router.post("/", response_model=PetRead, status_code=status.HTTP_201_CREATED)
async def create_pet(
    pet_data: PetCreate,
    db: AsyncSession = Depends(get_db)
):
    """반려동물 등록"""
    # TODO: 실제 user_id 설정 구현 (현재는 Mock user 사용)
    mock_user = await get_or_create_mock_user(db)
    
    pet = Pet(
        user_id=mock_user.id,
        name=pet_data.name,
        breed_code=pet_data.breed_code,
        weight_bucket_code=pet_data.weight_bucket_code,
        age_stage=pet_data.age_stage,
        is_neutered=pet_data.is_neutered,
        is_primary=pet_data.is_primary if pet_data.is_primary is not None else False,
    )
    db.add(pet)
    await db.commit()
    await db.refresh(pet)
    return PetRead.model_validate(pet)


@router.get("/{pet_id}", response_model=PetRead)
async def get_pet(pet_id: UUID, db: AsyncSession = Depends(get_db)):
    """반려동물 상세 조회"""
    result = await db.execute(select(Pet).where(Pet.id == pet_id))
    pet = result.scalar_one_or_none()
    
    if pet is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pet not found"
        )
    
    return PetRead.model_validate(pet)
