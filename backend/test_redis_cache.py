"""Redis 캐시 테스트 스크립트"""
import asyncio
import sys
from uuid import uuid4
from datetime import datetime

# 프로젝트 루트를 경로에 추가
sys.path.insert(0, '.')

from app.core.redis import init_redis, close_redis, get_redis
from app.core.cache.recommendation_cache_service import RecommendationCacheService
from app.core.cache.cache_keys import CacheKeys
from app.schemas.product import RecommendationResponse, RecommendationItem as RecommendationItemSchema
from app.schemas.product import ProductRead


async def test_redis_connection():
    """Redis 연결 테스트"""
    print("\n=== 1. Redis 연결 테스트 ===")
    try:
        await init_redis()
        redis_client = await get_redis()
        result = await redis_client.ping()
        print(f"✅ Redis 연결 성공: {result}")
        return True
    except Exception as e:
        print(f"❌ Redis 연결 실패: {e}")
        return False


async def test_cache_keys():
    """캐시 키 생성 테스트"""
    print("\n=== 2. 캐시 키 생성 테스트 ===")
    pet_id = uuid4()
    
    result_key = CacheKeys.recommendation_result(pet_id)
    meta_key = CacheKeys.recommendation_meta(pet_id)
    tags_key = CacheKeys.recommendation_tags(pet_id)
    pet_key = CacheKeys.pet_summary(pet_id)
    
    print(f"✅ 추천 결과 키: {result_key}")
    print(f"✅ 메타데이터 키: {meta_key}")
    print(f"✅ 태그 키: {tags_key}")
    print(f"✅ 펫 프로필 키: {pet_key}")


async def test_cache_set_get():
    """캐시 저장/조회 테스트"""
    print("\n=== 3. 캐시 저장/조회 테스트 ===")
    pet_id = uuid4()
    
    # 테스트용 추천 응답 생성
    recommendation = RecommendationResponse(
        pet_id=pet_id,
        items=[],
        is_cached=True,
        last_recommended_at=datetime.now()
    )
    
    # 저장
    print(f"📝 캐시 저장 시도: pet_id={pet_id}")
    saved = await RecommendationCacheService.set_recommendation(pet_id, recommendation)
    print(f"{'✅' if saved else '❌'} 캐시 저장: {saved}")
    
    # 조회
    print(f"📖 캐시 조회 시도: pet_id={pet_id}")
    cached = await RecommendationCacheService.get_recommendation(pet_id)
    if cached:
        print(f"✅ 캐시 조회 성공: pet_id={cached.pet_id}, is_cached={cached.is_cached}")
    else:
        print("❌ 캐시 조회 실패: 캐시가 없습니다")


async def test_cache_invalidation():
    """캐시 무효화 테스트"""
    print("\n=== 4. 캐시 무효화 테스트 ===")
    pet_id = uuid4()
    
    # 먼저 캐시 저장
    recommendation = RecommendationResponse(
        pet_id=pet_id,
        items=[],
        is_cached=True,
        last_recommended_at=datetime.now()
    )
    await RecommendationCacheService.set_recommendation(pet_id, recommendation)
    print(f"📝 캐시 저장 완료: pet_id={pet_id}")
    
    # 조회 확인
    cached = await RecommendationCacheService.get_recommendation(pet_id)
    print(f"{'✅' if cached else '❌'} 무효화 전 조회: {cached is not None}")
    
    # 무효화
    print(f"🗑️ 캐시 무효화 시도: pet_id={pet_id}")
    invalidated = await RecommendationCacheService.invalidate_recommendation(pet_id)
    print(f"{'✅' if invalidated else '❌'} 캐시 무효화: {invalidated}")
    
    # 다시 조회 (없어야 함)
    cached_after = await RecommendationCacheService.get_recommendation(pet_id)
    print(f"{'✅' if cached_after is None else '❌'} 무효화 후 조회 (None이어야 함): {cached_after is None}")


async def test_pet_summary_cache():
    """펫 프로필 캐시 테스트"""
    print("\n=== 5. 펫 프로필 캐시 테스트 ===")
    pet_id = uuid4()
    
    summary = {
        "name": "테스트 펫",
        "species": "DOG",
        "weight_kg": 10.5
    }
    
    # 저장
    saved = await RecommendationCacheService.set_pet_summary(pet_id, summary)
    print(f"{'✅' if saved else '❌'} 펫 프로필 캐시 저장: {saved}")
    
    # 조회
    cached = await RecommendationCacheService.get_pet_summary(pet_id)
    if cached:
        print(f"✅ 펫 프로필 캐시 조회 성공: {cached}")
    else:
        print("❌ 펫 프로필 캐시 조회 실패")
    
    # 무효화
    invalidated = await RecommendationCacheService.invalidate_pet_summary(pet_id)
    print(f"{'✅' if invalidated else '❌'} 펫 프로필 캐시 무효화: {invalidated}")


async def test_redis_fallback():
    """Redis 실패 시 fallback 테스트"""
    print("\n=== 6. Redis Fallback 테스트 ===")
    print("⚠️ 이 테스트는 Redis가 정상 작동할 때는 항상 성공합니다")
    print("⚠️ 실제 fallback 테스트는 Redis를 중지한 상태에서 API 호출로 확인해야 합니다")


async def main():
    """메인 테스트 함수"""
    print("=" * 60)
    print("Redis 캐시 구현 테스트")
    print("=" * 60)
    
    try:
        # 1. Redis 연결 테스트
        if not await test_redis_connection():
            print("\n❌ Redis 연결 실패. 테스트를 중단합니다.")
            print("💡 Redis 서버를 시작하세요: redis-server")
            return
        
        # 2. 캐시 키 생성 테스트
        await test_cache_keys()
        
        # 3. 캐시 저장/조회 테스트
        await test_cache_set_get()
        
        # 4. 캐시 무효화 테스트
        await test_cache_invalidation()
        
        # 5. 펫 프로필 캐시 테스트
        await test_pet_summary_cache()
        
        # 6. Fallback 안내
        await test_redis_fallback()
        
        print("\n" + "=" * 60)
        print("✅ 모든 테스트 완료!")
        print("=" * 60)
        
    except Exception as e:
        print(f"\n❌ 테스트 중 오류 발생: {e}")
        import traceback
        traceback.print_exc()
    finally:
        await close_redis()


if __name__ == "__main__":
    asyncio.run(main())
