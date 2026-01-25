from pydantic_settings import BaseSettings
from typing import Optional


class Settings(BaseSettings):
    # Database
    DATABASE_URL: str = "postgresql+asyncpg://postgres:postgres@localhost:5432/petfood"
    
    # Redis
    REDIS_URL: str = "redis://localhost:6379/0"
    
    # Security
    SECRET_KEY: str = "your-secret-key-change-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # API Keys
    AFFILIATE_API_KEY: Optional[str] = None
    
    # Worker Settings
    PRICE_COLLECTOR_INTERVAL_MINUTES: int = 60
    
    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()

