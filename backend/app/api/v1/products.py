"""상품 API 라우터 - 라우팅만 담당"""
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID
from sqlalchemy import select

from app.db.session import get_db
from app.schemas.product import ProductRead, RecommendationResponse
from app.services.product_service import ProductService
from app.models.offer import ProductOffer


router = APIRouter()


@router.get("/", response_model=list[ProductRead])
async def get_products(db: AsyncSession = Depends(get_db)):
    """상품 목록 조회"""
    products = await ProductService.get_active_products(db)
    return [ProductRead.model_validate(p) for p in products]


@router.get("/recommendations", response_model=RecommendationResponse)
async def get_recommendations(
    pet_id: UUID = Query(..., description="반려동물 ID"),
    db: AsyncSession = Depends(get_db)
):
    """추천 상품 목록 조회"""
    return await ProductService.get_recommendations(pet_id, db)


@router.get("/{product_id}", response_model=ProductRead)
async def get_product(
    product_id: UUID,
    db: AsyncSession = Depends(get_db)
):
    """상품 상세 조회"""
    product = await ProductService.get_product_by_id(product_id, db)
    return ProductRead.model_validate(product)


@router.get("/{product_id}/offers")
async def get_product_offers(
    product_id: UUID,
    db: AsyncSession = Depends(get_db)
):
    """상품의 판매처 목록 조회"""
    result = await db.execute(
        select(ProductOffer).where(ProductOffer.product_id == product_id)
    )
    offers = result.scalars().all()
    return [{"id": str(o.id), "merchant": o.merchant.value, "url": o.url} for o in offers]
