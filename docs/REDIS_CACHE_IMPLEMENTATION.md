# Redis 추천 캐시 구현 설계 (구체화)

## 1. 현재 상태 분석

### 1.1 기존 인프라
- ✅ Redis 클라이언트 설정 완료 (`backend/app/core/redis.py`)
- ✅ `SectionCacheService` 패턴 존재 (참고 가능)
- ✅ Redis 연결 풀 및 초기화 로직 구현됨
- ❌ 추천 결과 Redis 캐싱 미구현 (PostgreSQL만 사용)

### 1.2 기존 코드 패턴
```python
# SectionCacheService 패턴 (참고)
class SectionCacheService:
    @staticmethod
    async def get_cached_section(...) -> Optional[List[ProductRead]]
    @staticmethod
    async def set_cached_section(...) -> None
    @staticmethod
    async def invalidate_section(...) -> None
```

---

## 2. 구체적 구현 설계

### 2.1 파일 구조

```
backend/app/
├── core/
│   ├── redis.py (기존, 유지)
│   └── cache/
│       ├── __init__.py
│       ├── cache_keys.py (캐시 키 생성 유틸)
│       └── recommendation_cache_service.py (추천 캐시 서비스)
├── services/
│   └── product_service.py (캐시 로직 통합)
```

### 2.2 캐시 키 관리 (`cache_keys.py`)

```python
"""캐시 키 생성 및 관리"""
from uuid import UUID

class CacheKeys:
    """캐시 키 네이밍 컨벤션"""
    NAMESPACE = "petfood"
    
    @staticmethod
    def recommendation_result(pet_id: UUID) -> str:
        """추천 결과 캐시 키"""
        return f"{CacheKeys.NAMESPACE}:rec:result:{pet_id}"
    
    @staticmethod
    def recommendation_meta(pet_id: UUID) -> str:
        """추천 메타데이터 캐시 키"""
        return f"{CacheKeys.NAMESPACE}:rec:meta:{pet_id}"
    
    @staticmethod
    def recommendation_tags(pet_id: UUID) -> str:
        """추천 태그 캐시 키 (무효화용)"""
        return f"{CacheKeys.NAMESPACE}:rec:tags:{pet_id}"
    
    @staticmethod
    def pet_summary(pet_id: UUID) -> str:
        """펫 프로필 캐시 키"""
        return f"{CacheKeys.NAMESPACE}:pet:summary:{pet_id}"
    
    @staticmethod
    def product_match_score(product_id: UUID, pet_id: UUID) -> str:
        """상품 맞춤 점수 캐시 키"""
        return f"{CacheKeys.NAMESPACE}:product:match:{product_id}:{pet_id}"
```

### 2.3 추천 캐시 서비스 (`recommendation_cache_service.py`)

```python
"""추천 결과 Redis 캐싱 서비스"""
import json
import logging
from typing import Optional
from uuid import UUID
from datetime import datetime, timezone

import redis.asyncio as redis

from app.core.redis import get_redis
from app.core.cache.cache_keys import CacheKeys
from app.schemas.product import RecommendationResponse

logger = logging.getLogger(__name__)


class RecommendationCacheService:
    """추천 결과 Redis 캐싱 서비스"""
    
    # TTL 설정 (초)
    RECOMMENDATION_TTL = 7 * 24 * 60 * 60  # 7일
    PET_SUMMARY_TTL = 60 * 60  # 1시간
    PRODUCT_MATCH_SCORE_TTL = 60 * 60  # 1시간
    
    @staticmethod
    async def get_recommendation(pet_id: UUID) -> Optional[RecommendationResponse]:
        """
        Redis에서 추천 결과 조회
        
        Returns:
            RecommendationResponse 또는 None (캐시 미스)
        """
        try:
            redis_client = await get_redis()
            cache_key = CacheKeys.recommendation_result(pet_id)
            
            cached_data = await redis_client.get(cache_key)
            if cached_data:
                logger.info(f"[RecommendationCache] ✅ 캐시 히트: pet_id={pet_id}")
                data = json.loads(cached_data)
                # datetime 문자열을 datetime 객체로 변환
                if 'last_recommended_at' in data and data['last_recommended_at']:
                    data['last_recommended_at'] = datetime.fromisoformat(data['last_recommended_at'])
                return RecommendationResponse(**data)
            
            logger.debug(f"[RecommendationCache] ❌ 캐시 미스: pet_id={pet_id}")
            return None
        except redis.RedisError as e:
            logger.warning(f"[RecommendationCache] Redis 조회 실패: {e}, fallback to PostgreSQL")
            return None
        except Exception as e:
            logger.error(f"[RecommendationCache] 예상치 못한 에러: {e}", exc_info=True)
            return None
    
    @staticmethod
    async def set_recommendation(
        pet_id: UUID,
        recommendation: RecommendationResponse,
        ttl: Optional[int] = None
    ) -> bool:
        """
        Redis에 추천 결과 저장
        
        Returns:
            저장 성공 여부
        """
        try:
            redis_client = await get_redis()
            cache_key = CacheKeys.recommendation_result(pet_id)
            ttl = ttl or RecommendationCacheService.RECOMMENDATION_TTL
            
            # Pydantic 모델을 dict로 변환 (datetime 처리)
            data = recommendation.model_dump(mode='json')
            
            await redis_client.setex(
                cache_key,
                ttl,
                json.dumps(data, default=str)
            )
            
            logger.info(f"[RecommendationCache] ✅ 캐시 저장: pet_id={pet_id}, TTL={ttl}초")
            return True
        except redis.RedisError as e:
            logger.warning(f"[RecommendationCache] Redis 저장 실패: {e}")
            return False
        except Exception as e:
            logger.error(f"[RecommendationCache] 예상치 못한 에러: {e}", exc_info=True)
            return False
    
    @staticmethod
    async def invalidate_recommendation(pet_id: UUID) -> bool:
        """
        특정 펫의 추천 캐시 무효화
        
        Returns:
            삭제 성공 여부
        """
        try:
            redis_client = await get_redis()
            cache_key = CacheKeys.recommendation_result(pet_id)
            meta_key = CacheKeys.recommendation_meta(pet_id)
            tags_key = CacheKeys.recommendation_tags(pet_id)
            
            deleted = await redis_client.delete(cache_key, meta_key, tags_key)
            logger.info(f"[RecommendationCache] ✅ 캐시 무효화: pet_id={pet_id}, deleted={deleted}개 키")
            return deleted > 0
        except redis.RedisError as e:
            logger.warning(f"[RecommendationCache] 캐시 무효화 실패: {e}")
            return False
        except Exception as e:
            logger.error(f"[RecommendationCache] 예상치 못한 에러: {e}", exc_info=True)
            return False
    
    @staticmethod
    async def invalidate_all_recommendations() -> int:
        """
        모든 추천 캐시 무효화 (관리자용)
        
        Returns:
            삭제된 키 개수
        """
        try:
            redis_client = await get_redis()
            pattern = f"{CacheKeys.NAMESPACE}:rec:*"
            
            keys = []
            async for key in redis_client.scan_iter(match=pattern):
                keys.append(key)
            
            if keys:
                deleted = await redis_client.delete(*keys)
                logger.info(f"[RecommendationCache] ✅ 전체 캐시 무효화: {deleted}개 키 삭제")
                return deleted
            
            return 0
        except redis.RedisError as e:
            logger.warning(f"[RecommendationCache] 전체 캐시 무효화 실패: {e}")
            return 0
        except Exception as e:
            logger.error(f"[RecommendationCache] 예상치 못한 에러: {e}", exc_info=True)
            return 0
    
    @staticmethod
    async def get_pet_summary(pet_id: UUID) -> Optional[dict]:
        """펫 프로필 캐시 조회"""
        try:
            redis_client = await get_redis()
            cache_key = CacheKeys.pet_summary(pet_id)
            cached_data = await redis_client.get(cache_key)
            
            if cached_data:
                return json.loads(cached_data)
            return None
        except Exception as e:
            logger.warning(f"[RecommendationCache] 펫 프로필 캐시 조회 실패: {e}")
            return None
    
    @staticmethod
    async def set_pet_summary(pet_id: UUID, summary: dict, ttl: Optional[int] = None) -> bool:
        """펫 프로필 캐시 저장"""
        try:
            redis_client = await get_redis()
            cache_key = CacheKeys.pet_summary(pet_id)
            ttl = ttl or RecommendationCacheService.PET_SUMMARY_TTL
            
            await redis_client.setex(
                cache_key,
                ttl,
                json.dumps(summary, default=str)
            )
            return True
        except Exception as e:
            logger.warning(f"[RecommendationCache] 펫 프로필 캐시 저장 실패: {e}")
            return False
    
    @staticmethod
    async def invalidate_pet_summary(pet_id: UUID) -> bool:
        """펫 프로필 캐시 무효화"""
        try:
            redis_client = await get_redis()
            cache_key = CacheKeys.pet_summary(pet_id)
            deleted = await redis_client.delete(cache_key)
            return deleted > 0
        except Exception as e:
            logger.warning(f"[RecommendationCache] 펫 프로필 캐시 무효화 실패: {e}")
            return False
```

### 2.4 ProductService 통합

#### 2.4.1 `get_recommendations()` 메서드 수정

**현재 흐름**:
```
1. PostgreSQL에서 캐시 확인 (7일 이내 RecommendationRun)
2. 있으면 → 반환
3. 없으면 → 새로 계산 → PostgreSQL 저장
```

**개선된 흐름**:
```
1. Redis에서 캐시 확인
   ├─ Hit: 즉시 반환
   └─ Miss: PostgreSQL 확인
       ├─ Hit: Redis에 저장 후 반환
       └─ Miss: 새로 계산 → Redis + PostgreSQL 저장
```

**구체적 코드 위치**:
- 파일: `backend/app/services/product_service.py`
- 메서드: `get_recommendations()` (라인 82-241)
- 수정 포인트:
  1. 라인 109-241: 캐시 체크 로직 앞에 Redis 조회 추가
  2. 라인 242 이후: 새로 계산 후 Redis 저장 추가
  3. 라인 255-241: PostgreSQL 조회 후 Redis 저장 추가

#### 2.4.2 코드 수정 예시

```python
# ProductService.get_recommendations() 시작 부분
@staticmethod
async def get_recommendations(
    pet_id: UUID,
    db: AsyncSession,
    force_refresh: bool = False,
    generate_explanation_only: bool = False
) -> RecommendationResponse:
    # ... 기존 코드 ...
    
    # UPDATED: Redis 캐시 체크 (force_refresh가 False일 때만)
    if not force_refresh:
        from app.core.cache.recommendation_cache_service import RecommendationCacheService
        
        cached_recommendation = await RecommendationCacheService.get_recommendation(pet_id)
        if cached_recommendation:
            logger.info(f"[ProductService] ✅ Redis 캐시 히트: pet_id={pet_id}")
            return cached_recommendation
        
        logger.debug(f"[ProductService] ❌ Redis 캐시 미스: pet_id={pet_id}, PostgreSQL 확인")
    
    # 기존 PostgreSQL 캐시 체크 로직 (라인 109-241)
    if not force_refresh:
        cache_threshold = datetime.now(timezone.utc) - timedelta(days=7)
        # ... 기존 코드 ...
        
        if latest_run and latest_created_at >= cache_threshold:
            # ... 기존 코드로 RecommendationResponse 생성 ...
            
            # UPDATED: PostgreSQL에서 가져온 결과를 Redis에 저장
            await RecommendationCacheService.set_recommendation(pet_id, recommendation_response)
            logger.info(f"[ProductService] ✅ PostgreSQL → Redis 캐시 저장 완료")
            
            return recommendation_response
    
    # 새로 계산하는 경우 (라인 242 이후)
    # ... 기존 계산 로직 ...
    
    # UPDATED: 계산 완료 후 Redis + PostgreSQL 저장
    recommendation_response = RecommendationResponse(...)
    await RecommendationCacheService.set_recommendation(pet_id, recommendation_response)
    # ... 기존 PostgreSQL 저장 로직 ...
```

### 2.5 캐시 무효화 통합

#### 2.5.1 펫 프로필 업데이트 시

**파일**: `backend/app/api/v1/pets.py` 또는 `backend/app/services/pet_service.py`

**수정 위치**: 펫 업데이트 메서드 내부

```python
# 펫 업데이트 후
await RecommendationCacheService.invalidate_recommendation(pet_id)
await RecommendationCacheService.invalidate_pet_summary(pet_id)
logger.info(f"[PetService] ✅ 추천 캐시 무효화: pet_id={pet_id}")
```

#### 2.5.2 수동 캐시 삭제 API

**파일**: `backend/app/api/v1/products.py`

**메서드**: `clear_recommendation_cache()` (라인 1346-1388)

```python
@router.delete("/recommendations/cache", status_code=status.HTTP_200_OK)
async def clear_recommendation_cache(
    pet_id: UUID = Query(..., description="반려동물 ID"),
    db: AsyncSession = Depends(get_db)
):
    """추천 캐시 제거 (Redis + PostgreSQL)"""
    from app.core.cache.recommendation_cache_service import RecommendationCacheService
    
    # Redis 캐시 삭제
    redis_deleted = await RecommendationCacheService.invalidate_recommendation(pet_id)
    
    # PostgreSQL 캐시 삭제 (기존 로직)
    db_deleted = await ProductService.clear_recommendation_cache(pet_id, db)
    
    return {
        "deleted_runs": db_deleted,
        "redis_keys_deleted": 1 if redis_deleted else 0
    }
```

---

## 3. 에러 처리 및 Fallback 전략

### 3.1 Redis 연결 실패

```python
try:
    cached = await RecommendationCacheService.get_recommendation(pet_id)
except Exception as e:
    logger.warning(f"[ProductService] Redis 조회 실패, PostgreSQL로 fallback: {e}")
    cached = None

if cached:
    return cached

# PostgreSQL 조회 (기존 로직)
```

### 3.2 Redis 저장 실패

```python
# 계산 완료 후
recommendation_response = RecommendationResponse(...)

# Redis 저장 시도 (실패해도 계속 진행)
try:
    await RecommendationCacheService.set_recommendation(pet_id, recommendation_response)
except Exception as e:
    logger.warning(f"[ProductService] Redis 저장 실패 (무시하고 계속): {e}")

# PostgreSQL 저장 (필수)
# ... 기존 로직 ...
```

### 3.3 Circuit Breaker (선택사항)

```python
class RedisCircuitBreaker:
    """Redis 장애 시 자동 차단"""
    def __init__(self):
        self.failure_count = 0
        self.last_failure_time = None
        self.state = "CLOSED"  # CLOSED, OPEN, HALF_OPEN
        self.threshold = 5  # 5회 실패 시 차단
        self.timeout = 60  # 60초 후 재시도
    
    async def execute(self, func):
        if self.state == "OPEN":
            if time.time() - self.last_failure_time > self.timeout:
                self.state = "HALF_OPEN"
            else:
                raise RedisUnavailableException("Redis circuit breaker is OPEN")
        
        try:
            result = await func()
            if self.state == "HALF_OPEN":
                self.state = "CLOSED"
                self.failure_count = 0
            return result
        except Exception as e:
            self.failure_count += 1
            self.last_failure_time = time.time()
            if self.failure_count >= self.threshold:
                self.state = "OPEN"
                logger.error(f"[RedisCircuitBreaker] Circuit breaker OPEN: {e}")
            raise
```

---

## 4. 테스트 전략

### 4.1 단위 테스트

```python
# tests/test_recommendation_cache_service.py
import pytest
from uuid import uuid4
from app.core.cache.recommendation_cache_service import RecommendationCacheService

@pytest.mark.asyncio
async def test_get_recommendation_cache_hit():
    """캐시 히트 테스트"""
    pet_id = uuid4()
    # 캐시 저장
    # 캐시 조회
    # 결과 검증

@pytest.mark.asyncio
async def test_get_recommendation_cache_miss():
    """캐시 미스 테스트"""
    # 캐시 없는 상태에서 조회
    # None 반환 확인

@pytest.mark.asyncio
async def test_invalidate_recommendation():
    """캐시 무효화 테스트"""
    # 캐시 저장
    # 무효화
    # 조회 시 None 반환 확인
```

### 4.2 통합 테스트

```python
# tests/test_product_service_with_cache.py
@pytest.mark.asyncio
async def test_get_recommendations_redis_fallback():
    """Redis 실패 시 PostgreSQL fallback 테스트"""
    # Redis 연결 차단
    # 추천 요청
    # PostgreSQL에서 결과 반환 확인
```

---

## 5. 모니터링 및 로깅

### 5.1 메트릭 수집

```python
# app/core/cache/recommendation_cache_service.py
class CacheMetrics:
    hit_count = 0
    miss_count = 0
    error_count = 0
    
    @classmethod
    def record_hit(cls):
        cls.hit_count += 1
        logger.info(f"[CacheMetrics] Hit Rate: {cls._get_hit_rate():.2%}")
    
    @classmethod
    def record_miss(cls):
        cls.miss_count += 1
    
    @classmethod
    def _get_hit_rate(cls) -> float:
        total = cls.hit_count + cls.miss_count
        return cls.hit_count / total if total > 0 else 0.0
```

### 5.2 로깅 포인트

```python
# 캐시 히트
logger.info(f"[RecommendationCache] ✅ Redis Hit: pet_id={pet_id}, duration={duration}ms")

# 캐시 미스
logger.info(f"[RecommendationCache] ❌ Redis Miss: pet_id={pet_id}, fallback=PostgreSQL")

# Redis 에러
logger.warning(f"[RecommendationCache] Redis Error: {error}, fallback=PostgreSQL")

# 캐시 저장
logger.info(f"[RecommendationCache] ✅ Cache Saved: pet_id={pet_id}, TTL={ttl}초")

# 캐시 무효화
logger.info(f"[RecommendationCache] ✅ Cache Invalidated: pet_id={pet_id}, keys_deleted={count}")
```

---

## 6. 구현 순서

### Phase 1: 기본 캐시 레이어 (1일)
1. ✅ `cache_keys.py` 생성
2. ✅ `recommendation_cache_service.py` 생성
3. ✅ 기본 테스트 작성

### Phase 2: ProductService 통합 (1일)
1. ✅ `get_recommendations()`에 Redis 조회 추가
2. ✅ PostgreSQL 조회 후 Redis 저장 추가
3. ✅ 새 계산 후 Redis 저장 추가
4. ✅ 에러 처리 및 fallback 구현

### Phase 3: 캐시 무효화 (반일)
1. ✅ 펫 업데이트 시 무효화 추가
2. ✅ 수동 캐시 삭제 API 수정
3. ✅ 테스트

### Phase 4: 최적화 (선택사항)
1. 펫 프로필 캐시 추가
2. 상품 맞춤 점수 캐시 추가
3. Circuit Breaker 구현
4. 메트릭 수집

---

## 7. 예상 성능 개선

| 시나리오 | 현재 (PostgreSQL만) | 개선 후 (Redis) | 개선율 |
|---------|-------------------|----------------|--------|
| 캐시 히트 | 50-100ms | 1-5ms | **90-95% 감소** |
| 캐시 미스 (PostgreSQL 있음) | 50-100ms | 50-100ms + 1-5ms (Redis 저장) | 동일 |
| 캐시 미스 (새 계산) | 2-5초 (RAG 포함) | 2-5초 + 1-5ms (Redis 저장) | 동일 |

**예상 캐시 히트율**: 80-90% (7일 TTL 기준)

---

## 8. 주의사항

### 8.1 JSON 직렬화
- `datetime` 객체는 ISO8601 문자열로 변환 필요
- `UUID` 객체는 문자열로 변환 필요
- Pydantic의 `model_dump(mode='json')` 사용 권장

### 8.2 메모리 관리
- 추천 결과 크기 모니터링
- 필요 시 압축 고려 (gzip)
- Redis 메모리 사용량 모니터링

### 8.3 일관성
- Redis와 PostgreSQL 간 데이터 일관성 유지
- 무효화 시 양쪽 모두 삭제
- 저장 실패 시 로깅 및 모니터링

---

## 9. 다음 단계

1. **구현 시작**: Phase 1부터 순차적으로 진행
2. **테스트**: 각 Phase마다 테스트 작성 및 검증
3. **모니터링**: 프로덕션 배포 후 메트릭 확인
4. **최적화**: 필요 시 Phase 4 진행

이 설계로 바로 구현 가능합니다. 🚀
