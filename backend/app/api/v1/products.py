from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from uuid import UUID

from app.db.session import get_db
from app.schemas.product import ProductRead, RecommendationResponse, RecommendationItem
from app.models.product import Product
from app.models.offer import ProductOffer, Merchant
from app.models.price import PriceSummary


router = APIRouter()


@router.get("/", response_model=list[ProductRead])
async def get_products(db: AsyncSession = Depends(get_db)):
    """상품 목록 조회"""
    result = await db.execute(select(Product).where(Product.is_active == True))
    products = result.scalars().all()
    return [ProductRead.model_validate(p) for p in products]


@router.get("/recommendations", response_model=RecommendationResponse)
async def get_recommendations(
    pet_id: UUID = Query(..., description="반려동물 ID"),
    db: AsyncSession = Depends(get_db)
):
    """추천 상품 목록 조회"""
    # TODO: 실제 추천 로직 구현
    # 현재는 스텁 데이터 반환
    
    # Mock 데이터 생성
    mock_items = [
        RecommendationItem(
            product=ProductRead(
                id=UUID("00000000-0000-0000-0000-000000000001"),
                brand_name="로얄캐닌",
                product_name="미니 어덜트",
                size_label="3kg",
                is_active=True,
            ),
            offer_merchant=Merchant.COUPANG,
            current_price=35000,
            avg_price=38000,
            delta_percent=-7.89,
            is_new_low=True,
        ),
        RecommendationItem(
            product=ProductRead(
                id=UUID("00000000-0000-0000-0000-000000000002"),
                brand_name="힐스",
                product_name="사이언스 다이어트",
                size_label="5kg",
                is_active=True,
            ),
            offer_merchant=Merchant.NAVER,
            current_price=45000,
            avg_price=45000,
            delta_percent=0.0,
            is_new_low=False,
        ),
    ]
    
    return RecommendationResponse(
        pet_id=pet_id,
        items=mock_items,
    )


@router.get("/{product_id}", response_model=ProductRead)
async def get_product(product_id: UUID, db: AsyncSession = Depends(get_db)):
    """상품 상세 조회"""
    result = await db.execute(select(Product).where(Product.id == product_id))
    product = result.scalar_one_or_none()
    
    if product is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found"
        )
    
    return ProductRead.model_validate(product)


@router.get("/{product_id}/offers")
async def get_product_offers(product_id: UUID, db: AsyncSession = Depends(get_db)):
    """상품의 판매처 목록 조회"""
    result = await db.execute(
        select(ProductOffer).where(ProductOffer.product_id == product_id)
    )
    offers = result.scalars().all()
    return [{"id": str(o.id), "merchant": o.merchant.value, "url": o.url} for o in offers]
