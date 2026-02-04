"""
건강 고민 코드 및 알레르겐 코드 초기 데이터 삽입 스크립트
"""
import asyncio
import sys
from pathlib import Path

# 프로젝트 루트를 Python path에 추가
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy import text
from app.core.config import settings


# 건강 고민 코드 초기 데이터
HEALTH_CONCERN_CODES = [
    ('ALLERGY', '알레르기'),
    ('DIGESTIVE', '장/소화'),
    ('DENTAL', '치아/구강'),
    ('OBESITY', '비만'),
    ('RESPIRATORY', '호흡기'),
    ('SKIN', '피부/털'),
    ('JOINT', '관절'),
    ('EYE', '눈/눈물'),
    ('KIDNEY', '신장/요로'),
    ('HEART', '심장'),
    ('SENIOR', '노령'),
]

# 알레르겐 코드 초기 데이터
ALLERGEN_CODES = [
    ('BEEF', '소고기'),
    ('CHICKEN', '닭고기'),
    ('PORK', '돼지고기'),
    ('DUCK', '오리고기'),
    ('LAMB', '양고기'),
    ('FISH', '생선'),
    ('EGG', '계란'),
    ('DAIRY', '유제품'),
    ('WHEAT', '밀/글루텐'),
    ('CORN', '옥수수'),
    ('SOY', '콩'),
]


async def seed_code_tables():
    """건강 고민 코드 및 알레르겐 코드 초기 데이터 삽입"""
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
            # 건강 고민 코드 삽입
            health_concern_count = 0
            for code, display_name in HEALTH_CONCERN_CODES:
                result = await session.execute(
                    text("""
                        INSERT INTO health_concern_codes (code, display_name)
                        VALUES (:code, :display_name)
                        ON CONFLICT (code) DO NOTHING
                    """),
                    {"code": code, "display_name": display_name}
                )
                if result.rowcount > 0:
                    health_concern_count += 1
                    print(f"✓ 건강 고민 코드 생성: {code} - {display_name}")
            
            # 알레르겐 코드 삽입
            allergen_count = 0
            for code, display_name in ALLERGEN_CODES:
                result = await session.execute(
                    text("""
                        INSERT INTO allergen_codes (code, display_name)
                        VALUES (:code, :display_name)
                        ON CONFLICT (code) DO NOTHING
                    """),
                    {"code": code, "display_name": display_name}
                )
                if result.rowcount > 0:
                    allergen_count += 1
                    print(f"✓ 알레르겐 코드 생성: {code} - {display_name}")
            
            await session.commit()
            print(f"\n총 {health_concern_count}개의 건강 고민 코드와 {allergen_count}개의 알레르겐 코드가 생성되었습니다.")
            print("(이미 존재하는 코드는 건너뛰었습니다.)")
            
        except Exception as e:
            await session.rollback()
            print(f"❌ 오류 발생: {e}")
            raise
        finally:
            await engine.dispose()


if __name__ == "__main__":
    asyncio.run(seed_code_tables())
