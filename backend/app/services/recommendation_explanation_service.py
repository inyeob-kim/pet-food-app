"""추천 이유 설명 생성 서비스 (LLM 기반)"""
import logging
from typing import List, Optional
from app.utils.openai_client import get_openai_client
from app.core.config import settings

logger = logging.getLogger(__name__)

SYSTEM_PROMPT = """너는 반려동물 사료 추천 전문가다.
사용자에게 추천 이유를 친절하고 간결하게 설명해줘.
한국어로 자연스럽게 설명하고, 전문 용어는 피하고 쉬운 말로 풀어서 설명해줘.
설명은 1-2문장으로 간결하게 작성해줘."""

USER_PROMPT_TEMPLATE = """펫 정보:
- 이름: {pet_name}
- 종류: {pet_species}
- 나이 단계: {pet_age_stage}
- 체중: {pet_weight}kg
- 품종: {pet_breed}
- 중성화: {pet_neutered}
- 건강 고민: {health_concerns}
- 알레르기: {allergies}

추천 상품:
- 브랜드: {brand_name}
- 상품명: {product_name}

추천 이유 (기술적):
{technical_reasons}

위 정보를 바탕으로, 이 사료가 왜 이 펫에게 추천되는지 자연스럽고 친절하게 설명해줘.
설명은 1-2문장으로 간결하게 작성하고, 펫 이름을 사용해서 친근하게 설명해줘."""


class RecommendationExplanationService:
    """추천 이유 설명 생성 서비스"""
    
    @staticmethod
    async def generate_explanation(
        pet_name: str,
        pet_species: str,
        pet_age_stage: Optional[str],
        pet_weight: float,
        pet_breed: Optional[str],
        pet_neutered: Optional[bool],
        health_concerns: List[str],
        allergies: List[str],
        brand_name: str,
        product_name: str,
        technical_reasons: List[str]
    ) -> str:
        """
        추천 이유를 자연어로 생성
        
        Args:
            pet_name: 펫 이름
            pet_species: 펫 종류 (DOG/CAT)
            pet_age_stage: 나이 단계 (PUPPY/ADULT/SENIOR)
            pet_weight: 체중 (kg)
            pet_breed: 품종 코드
            pet_neutered: 중성화 여부
            health_concerns: 건강 고민 리스트
            allergies: 알레르기 리스트
            brand_name: 브랜드명
            product_name: 상품명
            technical_reasons: 기술적 추천 이유 리스트
        
        Returns:
            자연어 설명 문자열
        """
        try:
            # 기술적 이유를 문자열로 변환
            reasons_text = "\n".join([f"- {reason}" for reason in technical_reasons])
            
            # 나이 단계 한글 변환
            age_stage_kr = {
                "PUPPY": "강아지",
                "ADULT": "성견",
                "SENIOR": "노견"
            }.get(pet_age_stage or "", "성견")
            
            # 종류 한글 변환
            species_kr = "강아지" if pet_species == "DOG" else "고양이"
            
            # 중성화 여부 텍스트
            neutered_text = "완료" if pet_neutered else "미완료" if pet_neutered is False else "모름"
            
            # 건강 고민 텍스트
            health_concerns_text = ", ".join(health_concerns) if health_concerns else "없음"
            
            # 알레르기 텍스트
            allergies_text = ", ".join(allergies) if allergies else "없음"
            
            # 품종 텍스트
            breed_text = pet_breed or "정보 없음"
            
            prompt = USER_PROMPT_TEMPLATE.format(
                pet_name=pet_name,
                pet_species=species_kr,
                pet_age_stage=age_stage_kr,
                pet_weight=pet_weight,
                pet_breed=breed_text,
                pet_neutered=neutered_text,
                health_concerns=health_concerns_text,
                allergies=allergies_text,
                brand_name=brand_name,
                product_name=product_name,
                technical_reasons=reasons_text
            )
            
            client = get_openai_client()
            
            logger.info(f"[Explanation Service] LLM 설명 생성 시작: {pet_name} - {brand_name} {product_name}")
            
            response = client.chat.completions.create(
                model=settings.OPENAI_MODEL,
                temperature=0.7,  # 창의성 약간 높임
                max_tokens=200,  # 간결한 설명
                messages=[
                    {"role": "system", "content": SYSTEM_PROMPT},
                    {"role": "user", "content": prompt},
                ],
            )
            
            explanation = response.choices[0].message.content.strip()
            logger.info(f"[Explanation Service] LLM 설명 생성 완료: {explanation[:50]}...")
            
            return explanation
            
        except Exception as e:
            logger.error(f"[Explanation Service] LLM 설명 생성 실패: {str(e)}", exc_info=True)
            # 실패 시 기본 설명 반환
            return RecommendationExplanationService._generate_fallback_explanation(
                pet_name, technical_reasons
            )
    
    @staticmethod
    def _generate_fallback_explanation(pet_name: str, technical_reasons: List[str]) -> str:
        """LLM 실패 시 기본 설명 생성"""
        if not technical_reasons:
            return f"{pet_name}에게 적합한 사료입니다."
        
        # 주요 이유만 선택 (최대 3개)
        main_reasons = technical_reasons[:3]
        reasons_text = ", ".join(main_reasons)
        
        return f"{pet_name}에게 {reasons_text} 등의 이유로 추천되는 사료입니다."
