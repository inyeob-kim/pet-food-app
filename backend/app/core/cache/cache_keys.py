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
        return f"{CacheKeys.NAMESPACE}:rec:score:{pet_id}:{product_id}"
    
    @staticmethod
    def product_detail(product_id: UUID) -> str:
        """상품 상세 정보 캐시 키"""
        return f"{CacheKeys.NAMESPACE}:product:detail:{product_id}"
