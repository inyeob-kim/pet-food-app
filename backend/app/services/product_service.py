"""상품 관련 비즈니스 로직"""
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from fastapi import HTTPException, status

from app.models.product import Product
from app.schemas.product import ProductRead, RecommendationResponse, RecommendationItem
from app.models.offer import Merchant


class ProductService:
    """상품 서비스 - 상품 관련 비즈니스 로직만 담당"""
    
    @staticmethod
    async def get_active_products(db: AsyncSession) -> list[Product]:
        """활성 상품 목록 조회"""
        result = await db.execute(
            select(Product).where(Product.is_active == True)
        )
        return list(result.scalars().all())
    
    @staticmethod
    async def get_product_by_id(product_id: UUID, db: AsyncSession) -> Product:
        """상품 ID로 조회"""
        result = await db.execute(select(Product).where(Product.id == product_id))
        product = result.scalar_one_or_none()
        
        if product is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Product not found"
            )
        
        return product
    
    @staticmethod
    async def get_recommendations(
        pet_id: UUID,
        db: AsyncSession
    ) -> RecommendationResponse:
        """추천 상품 목록 조회 (비즈니스 로직)"""
        # TODO: 실제 추천 알고리즘 구현
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
