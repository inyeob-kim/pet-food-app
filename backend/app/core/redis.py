import redis.asyncio as redis
from typing import Optional
from app.core.config import settings

_redis_client: Optional[redis.Redis] = None


async def init_redis():
    """Redis 연결 초기화"""
    global _redis_client
    _redis_client = redis.from_url(
        settings.REDIS_URL,
        encoding="utf-8",
        decode_responses=True
    )


async def close_redis():
    """Redis 연결 종료"""
    global _redis_client
    if _redis_client:
        await _redis_client.close()
        _redis_client = None


async def get_redis() -> redis.Redis:
    """Redis 클라이언트 반환"""
    if _redis_client is None:
        await init_redis()
    return _redis_client

