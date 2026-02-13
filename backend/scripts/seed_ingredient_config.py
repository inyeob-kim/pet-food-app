"""성분 설정 초기 데이터 시딩 스크립트"""
import asyncio
import sys
from pathlib import Path

# 프로젝트 루트를 Python path에 추가
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from app.core.config import settings
from app.models.ingredient_config import HarmfulIngredient, AllergenKeyword
from app.db.base import Base


async def seed_harmful_ingredients(db: AsyncSession):
    """유해 성분 초기 데이터 시딩"""
    harmful_ingredients_data = [
        {"name": "인공색소", "description": "인공 색소 첨가제", "severity": 3},
        {"name": "인공향료", "description": "인공 향료 첨가제", "severity": 2},
        {"name": "BHA", "description": "부틸화 하이드록시 아니솔 (방부제)", "severity": 4},
        {"name": "BHT", "description": "부틸화 하이드록시 톨루엔 (방부제)", "severity": 4},
        {"name": "에톡시퀸", "description": "에톡시퀸 (방부제)", "severity": 5},
        {"name": "옥수수 시럽", "description": "고당류 함유", "severity": 2},
        {"name": "설탕", "description": "과도한 설탕 함유", "severity": 2},
        {"name": "소금 과다", "description": "과도한 나트륨 함유", "severity": 3},
    ]
    
    for data in harmful_ingredients_data:
        # 이미 존재하는지 확인
        from sqlalchemy import select
        result = await db.execute(
            select(HarmfulIngredient).where(HarmfulIngredient.name == data["name"])
        )
        existing = result.scalar_one_or_none()
        
        if existing:
            print(f"  ⏭️  유해 성분 '{data['name']}' 이미 존재, 스킵")
        else:
            harmful = HarmfulIngredient(**data)
            db.add(harmful)
            print(f"  ✅ 유해 성분 '{data['name']}' 추가")
    
    await db.commit()
    print(f"✅ 유해 성분 시딩 완료: {len(harmful_ingredients_data)}개")


async def seed_allergen_keywords(db: AsyncSession):
    """알레르기 키워드 초기 데이터 시딩"""
    allergen_keywords_data = [
        # BEEF
        {"allergen_code": "BEEF", "keyword": "소고기", "language": "ko"},
        {"allergen_code": "BEEF", "keyword": "beef", "language": "en"},
        {"allergen_code": "BEEF", "keyword": "소", "language": "ko"},
        
        # CHICKEN
        {"allergen_code": "CHICKEN", "keyword": "닭고기", "language": "ko"},
        {"allergen_code": "CHICKEN", "keyword": "chicken", "language": "en"},
        {"allergen_code": "CHICKEN", "keyword": "닭", "language": "ko"},
        
        # DAIRY
        {"allergen_code": "DAIRY", "keyword": "우유", "language": "ko"},
        {"allergen_code": "DAIRY", "keyword": "dairy", "language": "en"},
        {"allergen_code": "DAIRY", "keyword": "유제품", "language": "ko"},
        
        # WHEAT
        {"allergen_code": "WHEAT", "keyword": "밀", "language": "ko"},
        {"allergen_code": "WHEAT", "keyword": "wheat", "language": "en"},
        
        # SOY
        {"allergen_code": "SOY", "keyword": "대두", "language": "ko"},
        {"allergen_code": "SOY", "keyword": "soy", "language": "en"},
        {"allergen_code": "SOY", "keyword": "콩", "language": "ko"},
        
        # EGG
        {"allergen_code": "EGG", "keyword": "계란", "language": "ko"},
        {"allergen_code": "EGG", "keyword": "egg", "language": "en"},
        {"allergen_code": "EGG", "keyword": "난", "language": "ko"},
        
        # LAMB
        {"allergen_code": "LAMB", "keyword": "양고기", "language": "ko"},
        {"allergen_code": "LAMB", "keyword": "lamb", "language": "en"},
        {"allergen_code": "LAMB", "keyword": "양", "language": "ko"},
        
        # CORN
        {"allergen_code": "CORN", "keyword": "옥수수", "language": "ko"},
        {"allergen_code": "CORN", "keyword": "corn", "language": "en"},
        
        # FISH
        {"allergen_code": "FISH", "keyword": "생선", "language": "ko"},
        {"allergen_code": "FISH", "keyword": "fish", "language": "en"},
        {"allergen_code": "FISH", "keyword": "어류", "language": "ko"},
    ]
    
    for data in allergen_keywords_data:
        # 이미 존재하는지 확인
        from sqlalchemy import select, and_
        result = await db.execute(
            select(AllergenKeyword).where(
                and_(
                    AllergenKeyword.allergen_code == data["allergen_code"],
                    AllergenKeyword.keyword == data["keyword"]
                )
            )
        )
        existing = result.scalar_one_or_none()
        
        if existing:
            print(f"  ⏭️  알레르기 키워드 '{data['allergen_code']}' -> '{data['keyword']}' 이미 존재, 스킵")
        else:
            keyword = AllergenKeyword(**data)
            db.add(keyword)
            print(f"  ✅ 알레르기 키워드 '{data['allergen_code']}' -> '{data['keyword']}' 추가")
    
    await db.commit()
    print(f"✅ 알레르기 키워드 시딩 완료: {len(allergen_keywords_data)}개")


async def main():
    """메인 함수"""
    # 데이터베이스 연결
    database_url = settings.DATABASE_URL
    engine = create_async_engine(database_url, echo=False)
    async_session = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
    
    async with async_session() as db:
        try:
            print("🌱 성분 설정 초기 데이터 시딩 시작...")
            print()
            
            print("1️⃣ 유해 성분 시딩 중...")
            await seed_harmful_ingredients(db)
            print()
            
            print("2️⃣ 알레르기 키워드 시딩 중...")
            await seed_allergen_keywords(db)
            print()
            
            print("✅ 모든 시딩 완료!")
            
        except Exception as e:
            print(f"❌ 시딩 중 오류 발생: {str(e)}")
            await db.rollback()
            raise
        finally:
            await engine.dispose()


if __name__ == "__main__":
    asyncio.run(main())
