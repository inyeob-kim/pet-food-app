"""
사료 테스트 데이터 생성 스크립트
"""
import asyncio
import sys
from pathlib import Path

# 프로젝트 루트를 Python path에 추가
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from app.models.product import Product, PetSpecies
from app.models.offer import ProductOffer, Merchant
from app.core.config import settings


# 테스트 데이터
TEST_PRODUCTS = [
    # 강아지 사료
    {
        "brand_name": "로얄캐닌",
        "product_name": "로얄캐닌 미니 어덜트",
        "size_label": "3kg",
        "species": PetSpecies.DOG,
        "offers": [
            {
                "merchant": Merchant.COUPANG,
                "merchant_product_id": "coupang_royal_mini_3kg",
                "url": "https://www.coupang.com/vp/products/123456",
                "affiliate_url": "https://www.coupang.com/vp/products/123456?affiliateId=test",
                "seller_name": "로얄캐닌 공식몰",
                "is_primary": True,
            },
            {
                "merchant": Merchant.NAVER,
                "merchant_product_id": "naver_royal_mini_3kg",
                "url": "https://smartstore.naver.com/products/123456",
                "seller_name": "펫샵",
                "is_primary": False,
            },
        ],
    },
    {
        "brand_name": "로얄캐닌",
        "product_name": "로얄캐닌 미니 어덜트",
        "size_label": "7.5kg",
        "species": PetSpecies.DOG,
        "offers": [
            {
                "merchant": Merchant.COUPANG,
                "merchant_product_id": "coupang_royal_mini_7.5kg",
                "url": "https://www.coupang.com/vp/products/123457",
                "affiliate_url": "https://www.coupang.com/vp/products/123457?affiliateId=test",
                "seller_name": "로얄캐닌 공식몰",
                "is_primary": True,
            },
        ],
    },
    {
        "brand_name": "힐스",
        "product_name": "힐스 사이언스 다이어트 어덜트",
        "size_label": "3kg",
        "species": PetSpecies.DOG,
        "offers": [
            {
                "merchant": Merchant.COUPANG,
                "merchant_product_id": "coupang_hills_adult_3kg",
                "url": "https://www.coupang.com/vp/products/123458",
                "affiliate_url": "https://www.coupang.com/vp/products/123458?affiliateId=test",
                "seller_name": "힐스 공식몰",
                "is_primary": True,
            },
            {
                "merchant": Merchant.NAVER,
                "merchant_product_id": "naver_hills_adult_3kg",
                "url": "https://smartstore.naver.com/products/123458",
                "seller_name": "펫마트",
                "is_primary": False,
            },
        ],
    },
    {
        "brand_name": "오리젠",
        "product_name": "오리젠 오리지널 독",
        "size_label": "2.27kg",
        "species": PetSpecies.DOG,
        "offers": [
            {
                "merchant": Merchant.COUPANG,
                "merchant_product_id": "coupang_orijen_original_2.27kg",
                "url": "https://www.coupang.com/vp/products/123459",
                "affiliate_url": "https://www.coupang.com/vp/products/123459?affiliateId=test",
                "seller_name": "오리젠 공식몰",
                "is_primary": True,
            },
        ],
    },
    {
        "brand_name": "아카나",
        "product_name": "아카나 그래스랜드 독",
        "size_label": "2kg",
        "species": PetSpecies.DOG,
        "offers": [
            {
                "merchant": Merchant.COUPANG,
                "merchant_product_id": "coupang_acana_grassland_2kg",
                "url": "https://www.coupang.com/vp/products/123460",
                "affiliate_url": "https://www.coupang.com/vp/products/123460?affiliateId=test",
                "seller_name": "아카나 공식몰",
                "is_primary": True,
            },
            {
                "merchant": Merchant.NAVER,
                "merchant_product_id": "naver_acana_grassland_2kg",
                "url": "https://smartstore.naver.com/products/123460",
                "seller_name": "프리미엄펫샵",
                "is_primary": False,
            },
        ],
    },
    {
        "brand_name": "퍼피",
        "product_name": "퍼피 강아지 사료",
        "size_label": "3kg",
        "species": PetSpecies.DOG,
        "offers": [
            {
                "merchant": Merchant.COUPANG,
                "merchant_product_id": "coupang_puppy_3kg",
                "url": "https://www.coupang.com/vp/products/123461",
                "affiliate_url": "https://www.coupang.com/vp/products/123461?affiliateId=test",
                "seller_name": "퍼피 공식몰",
                "is_primary": True,
            },
        ],
    },
    {
        "brand_name": "네츄럴밸런스",
        "product_name": "네츄럴밸런스 리미티드 인그리디언트 독",
        "size_label": "2.5kg",
        "species": PetSpecies.DOG,
        "offers": [
            {
                "merchant": Merchant.COUPANG,
                "merchant_product_id": "coupang_natural_balance_2.5kg",
                "url": "https://www.coupang.com/vp/products/123462",
                "affiliate_url": "https://www.coupang.com/vp/products/123462?affiliateId=test",
                "seller_name": "네츄럴밸런스 공식몰",
                "is_primary": True,
            },
        ],
    },
    # 고양이 사료
    {
        "brand_name": "로얄캐닌",
        "product_name": "로얄캐닌 인도어 어덜트",
        "size_label": "3.5kg",
        "species": PetSpecies.CAT,
        "offers": [
            {
                "merchant": Merchant.COUPANG,
                "merchant_product_id": "coupang_royal_indoor_3.5kg",
                "url": "https://www.coupang.com/vp/products/123463",
                "affiliate_url": "https://www.coupang.com/vp/products/123463?affiliateId=test",
                "seller_name": "로얄캐닌 공식몰",
                "is_primary": True,
            },
            {
                "merchant": Merchant.NAVER,
                "merchant_product_id": "naver_royal_indoor_3.5kg",
                "url": "https://smartstore.naver.com/products/123463",
                "seller_name": "펫샵",
                "is_primary": False,
            },
        ],
    },
    {
        "brand_name": "힐스",
        "product_name": "힐스 사이언스 다이어트 인도어 고양이",
        "size_label": "3.5kg",
        "species": PetSpecies.CAT,
        "offers": [
            {
                "merchant": Merchant.COUPANG,
                "merchant_product_id": "coupang_hills_indoor_3.5kg",
                "url": "https://www.coupang.com/vp/products/123464",
                "affiliate_url": "https://www.coupang.com/vp/products/123464?affiliateId=test",
                "seller_name": "힐스 공식몰",
                "is_primary": True,
            },
        ],
    },
    {
        "brand_name": "오리젠",
        "product_name": "오리젠 캐츠 앤 키틴 프리",
        "size_label": "2.27kg",
        "species": PetSpecies.CAT,
        "offers": [
            {
                "merchant": Merchant.COUPANG,
                "merchant_product_id": "coupang_orijen_cats_2.27kg",
                "url": "https://www.coupang.com/vp/products/123465",
                "affiliate_url": "https://www.coupang.com/vp/products/123465?affiliateId=test",
                "seller_name": "오리젠 공식몰",
                "is_primary": True,
            },
            {
                "merchant": Merchant.NAVER,
                "merchant_product_id": "naver_orijen_cats_2.27kg",
                "url": "https://smartstore.naver.com/products/123465",
                "seller_name": "프리미엄펫샵",
                "is_primary": False,
            },
        ],
    },
    {
        "brand_name": "아카나",
        "product_name": "아카나 그래스랜드 캣",
        "size_label": "2kg",
        "species": PetSpecies.CAT,
        "offers": [
            {
                "merchant": Merchant.COUPANG,
                "merchant_product_id": "coupang_acana_grassland_cat_2kg",
                "url": "https://www.coupang.com/vp/products/123466",
                "affiliate_url": "https://www.coupang.com/vp/products/123466?affiliateId=test",
                "seller_name": "아카나 공식몰",
                "is_primary": True,
            },
        ],
    },
]


async def seed_products():
    """사료 테스트 데이터 생성"""
    # DB 연결
    engine = create_async_engine(
        settings.DATABASE_URL,
        echo=True,
    )
    
    async_session = async_sessionmaker(
        engine,
        class_=AsyncSession,
        expire_on_commit=False,
    )
    
    async with async_session() as session:
        try:
            created_count = 0
            for product_data in TEST_PRODUCTS:
                # 상품 생성
                product = Product(
                    category="FOOD",  # MVP는 FOOD만
                    brand_name=product_data["brand_name"],
                    product_name=product_data["product_name"],
                    size_label=product_data["size_label"],
                    species=product_data["species"],
                    is_active=True,
                )
                session.add(product)
                await session.flush()  # ID 생성
                
                # 판매처 생성
                for offer_data in product_data["offers"]:
                    offer = ProductOffer(
                        product_id=product.id,
                        merchant=offer_data["merchant"],
                        merchant_product_id=offer_data["merchant_product_id"],
                        url=offer_data["url"],
                        affiliate_url=offer_data.get("affiliate_url"),
                        seller_name=offer_data.get("seller_name"),
                        is_primary=offer_data.get("is_primary", False),
                        is_active=True,
                    )
                    session.add(offer)
                
                created_count += 1
                print(f"✓ 생성됨: {product.brand_name} {product.product_name} {product.size_label}")
            
            await session.commit()
            print(f"\n총 {created_count}개의 상품과 관련 판매처가 생성되었습니다.")
            
        except Exception as e:
            await session.rollback()
            print(f"❌ 오류 발생: {e}")
            raise
        finally:
            await engine.dispose()


if __name__ == "__main__":
    asyncio.run(seed_products())
