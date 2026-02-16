"""추천 결과 Redis 캐싱 서비스"""
import json
import logging
from typing import Optional
from uuid import UUID
from datetime import datetime

import redis.asyncio as redis

from app.core.redis import get_redis
from app.core.cache.cache_keys import CacheKeys
from app.schemas.product import RecommendationResponse, ProductMatchScoreResponse

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
    
    @staticmethod
    async def get_product_match_score(
        product_id: UUID,
        pet_id: UUID
    ) -> Optional[ProductMatchScoreResponse]:
        """
        Redis에서 상품 맞춤 점수 조회
        
        Returns:
            ProductMatchScoreResponse 또는 None (캐시 미스)
        """
        try:
            redis_client = await get_redis()
            cache_key = CacheKeys.product_match_score(product_id, pet_id)
            
            cached_data = await redis_client.get(cache_key)
            if cached_data:
                logger.info(f"[RecommendationCache] ✅ 맞춤 점수 캐시 히트: product_id={product_id}, pet_id={pet_id}")
                data = json.loads(cached_data)
                # datetime 문자열을 datetime 객체로 변환
                if 'calculated_at' in data and data['calculated_at']:
                    data['calculated_at'] = datetime.fromisoformat(data['calculated_at'])
                return ProductMatchScoreResponse(**data)
            
            logger.debug(f"[RecommendationCache] ❌ 맞춤 점수 캐시 미스: product_id={product_id}, pet_id={pet_id}")
            return None
        except redis.RedisError as e:
            logger.warning(f"[RecommendationCache] 맞춤 점수 Redis 조회 실패: {e}, fallback to calculation")
            return None
        except Exception as e:
            logger.error(f"[RecommendationCache] 맞춤 점수 조회 예상치 못한 에러: {e}", exc_info=True)
            return None
    
    @staticmethod
    async def set_product_match_score(
        product_id: UUID,
        pet_id: UUID,
        match_score: ProductMatchScoreResponse,
        ttl: Optional[int] = None
    ) -> bool:
        """
        Redis에 상품 맞춤 점수 저장
        
        Returns:
            저장 성공 여부
        """
        try:
            redis_client = await get_redis()
            cache_key = CacheKeys.product_match_score(product_id, pet_id)
            ttl = ttl or RecommendationCacheService.PRODUCT_MATCH_SCORE_TTL
            
            # Pydantic 모델을 dict로 변환 (datetime 처리)
            data = match_score.model_dump(mode='json')
            
            await redis_client.setex(
                cache_key,
                ttl,
                json.dumps(data, default=str)
            )
            
            logger.info(f"[RecommendationCache] ✅ 맞춤 점수 캐시 저장: product_id={product_id}, pet_id={pet_id}, TTL={ttl}초")
            return True
        except redis.RedisError as e:
            logger.warning(f"[RecommendationCache] 맞춤 점수 Redis 저장 실패: {e}")
            return False
        except Exception as e:
            logger.error(f"[RecommendationCache] 맞춤 점수 저장 예상치 못한 에러: {e}", exc_info=True)
            return False
    
    @staticmethod
    async def invalidate_product_match_score(
        product_id: UUID,
        pet_id: Optional[UUID] = None
    ) -> int:
        """
        상품 맞춤 점수 캐시 무효화
        
        Args:
            product_id: 상품 ID
            pet_id: 펫 ID (None이면 해당 상품의 모든 맞춤 점수 캐시 삭제)
        
        Returns:
            삭제된 키 개수
        """
        try:
            redis_client = await get_redis()
            
            if pet_id:
                # 특정 펫의 맞춤 점수만 삭제
                cache_key = CacheKeys.product_match_score(product_id, pet_id)
                deleted = await redis_client.delete(cache_key)
                logger.info(f"[RecommendationCache] ✅ 맞춤 점수 캐시 무효화: product_id={product_id}, pet_id={pet_id}, deleted={deleted}개")
                return deleted
            else:
                # 해당 상품의 모든 맞춤 점수 삭제 (모든 펫)
                pattern = f"{CacheKeys.NAMESPACE}:rec:score:*:{product_id}"
                keys = []
                async for key in redis_client.scan_iter(match=pattern):
                    keys.append(key)
                
                if keys:
                    deleted = await redis_client.delete(*keys)
                    logger.info(f"[RecommendationCache] ✅ 맞춤 점수 캐시 무효화: product_id={product_id}, deleted={deleted}개 키")
                    return deleted
                return 0
        except redis.RedisError as e:
            logger.warning(f"[RecommendationCache] 맞춤 점수 캐시 무효화 실패: {e}")
            return 0
        except Exception as e:
            logger.error(f"[RecommendationCache] 맞춤 점수 무효화 예상치 못한 에러: {e}", exc_info=True)
            return 0