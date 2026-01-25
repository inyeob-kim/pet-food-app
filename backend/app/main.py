"""
Pet Food App - FastAPI Backend

Alembic 마이그레이션 명령어:
1. 초기 마이그레이션 생성:
   alembic revision --autogenerate -m "init"

2. 마이그레이션 적용:
   alembic upgrade head

3. 마이그레이션 되돌리기:
   alembic downgrade -1

4. 현재 버전 확인:
   alembic current

주의사항:
- Docker Compose로 PostgreSQL이 실행 중이어야 합니다.
- .env 파일에 DATABASE_URL이 설정되어 있어야 합니다.
- 모델 변경 후 반드시 autogenerate로 revision을 생성하세요.
"""

from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.db.base import Base
from app.core.redis import init_redis, close_redis
from app.api.v1.router import api_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    await init_redis()
    yield
    # Shutdown
    await close_redis()


app = FastAPI(
    title="Pet Food App API",
    description="반려동물 사료 가격 추적 및 알림 서비스",
    version="1.0.0",
    lifespan=lifespan,
)

# FastAPI는 Pydantic v2를 사용하므로 datetime은 자동으로 ISO8601 형식으로 직렬화됩니다.
# UUID도 자동으로 문자열로 직렬화됩니다.

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
async def health_check():
    return {"status": "ok", "message": "Service is running"}


# API 라우터 연결
app.include_router(api_router, prefix="/api/v1")

