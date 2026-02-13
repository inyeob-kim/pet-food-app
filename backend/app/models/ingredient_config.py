"""성분 검출 설정 모델 (유해 성분, 알레르기 키워드)"""
from sqlalchemy import Column, String, Boolean, ForeignKey, Integer, Index
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid

from app.db.base import Base, TimestampMixin


class HarmfulIngredient(Base, TimestampMixin):
    """유해 성분 테이블"""
    __tablename__ = "harmful_ingredients"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(100), nullable=False, unique=True)  # 예: "인공색소", "BHA"
    description = Column(String(500), nullable=True)  # 설명 (선택)
    severity = Column(Integer, nullable=False, default=1)  # 심각도 (1-5, 높을수록 심각)
    is_active = Column(Boolean, default=True, nullable=False)  # 활성화 여부

    __table_args__ = (
        Index('idx_harmful_ingredients_active', 'is_active'),
        Index('idx_harmful_ingredients_name', 'name'),
    )

    def __repr__(self):
        return f"<HarmfulIngredient(name='{self.name}', severity={self.severity})>"


class AllergenKeyword(Base, TimestampMixin):
    """알레르기 키워드 매핑 테이블"""
    __tablename__ = "allergen_keywords"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    allergen_code = Column(String(20), nullable=False)  # 예: "BEEF", "CHICKEN"
    keyword = Column(String(100), nullable=False)  # 검색 키워드 (예: "소고기", "beef", "소")
    language = Column(String(10), nullable=False, default="ko")  # 언어 코드 (ko, en)
    is_active = Column(Boolean, default=True, nullable=False)  # 활성화 여부

    __table_args__ = (
        Index('idx_allergen_keywords_code', 'allergen_code'),
        Index('idx_allergen_keywords_keyword', 'keyword'),
        Index('idx_allergen_keywords_active', 'is_active'),
    )

    def __repr__(self):
        return f"<AllergenKeyword(allergen_code='{self.allergen_code}', keyword='{self.keyword}')>"
