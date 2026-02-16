# RAG 프롬프트 분석

## 📋 현재 RAG 프롬프트 구성

### 1. System Prompt (시스템 프롬프트)

```python
SYSTEM_PROMPT = """너는 반려동물 사료 추천 전문가다.
사용자에게 추천 이유를 친절하고 간결하게 설명해줘.
한국어로 자연스럽게 설명하고, 전문 용어는 피하고 쉬운 말로 풀어서 설명해줘.
설명은 1-2문장으로 간결하게 작성해줘."""
```

**역할**: LLM의 역할과 톤 설정
- 전문가 역할
- 친절하고 간결한 설명
- 한국어 사용
- 쉬운 말로 설명
- 1-2문장으로 간결하게

---

### 2. User Prompt Template (사용자 프롬프트 템플릿)

```python
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

사용자 선호도:
{user_prefs_text}

{rag_context}

위 정보를 바탕으로, 이 사료가 왜 이 펫에게 추천되는지 자연스럽고 친절하게 설명해줘.
참고 자료가 있으면 그것을 근거로 전문적이고 신뢰할 수 있는 설명을 해줘.
설명은 1-2문장으로 간결하게 작성하고, 펫 이름을 사용해서 친근하게 설명해줘.
사용자 선호도가 있으면 그것도 자연스럽게 언급해줘."""
```

**구성 요소**:
1. **펫 정보**: 이름, 종류, 나이 단계, 체중, 품종, 중성화, 건강 고민, 알레르기
2. **추천 상품**: 브랜드명, 상품명
3. **추천 이유 (기술적)**: `matchReasons` 리스트를 bullet point로 변환
4. **사용자 선호도**: weights_preset, hard_exclude_allergens, soft_avoid_ingredients, max_price_per_kg
5. **RAG 컨텍스트**: Vector Store에서 검색된 전문 문서 청크 (최대 3개)

---

### 3. RAG Context 생성 로직

```python
# RAG 컨텍스트 생성
rag_context = ""
if retrieved_chunks:
    rag_context = "\n참고 자료 (전문 문서):\n"
    for idx, chunk in enumerate(retrieved_chunks[:3], 1):  # 최대 3개만 사용
        source = chunk.get("source", "Unknown")
        content = chunk.get("content", "")[:300]  # 300자로 제한
        rag_context += f"{idx}. [{source}] {content}...\n"
else:
    rag_context = "\n참고 자료: 없음\n"
```

**형식**:
```
참고 자료 (전문 문서):
1. [veterinary_allergy_4th] 알레르기 관련 내용... (최대 300자)
2. [fediaf_2025] 영양 가이드라인 내용... (최대 300자)
3. [aafco_2025] 공식 발행물 내용... (최대 300자)
```

**제한사항**:
- 최대 3개 청크만 사용
- 각 청크는 최대 300자로 제한
- 출처(source) 메타데이터 포함

---

### 4. 실제 프롬프트 예시

#### 입력 데이터 예시:
```python
pet_name = "뽀삐"
pet_species = "강아지"  # "DOG" → "강아지"로 변환
pet_age_stage = "성견"  # "ADULT" → "성견"으로 변환
pet_weight = 5.2
pet_breed = "비글"
pet_neutered = "완료"
health_concerns = "비만, 관절"
allergies = "닭고기"
brand_name = "로얄캐닌"
product_name = "미니 어덜트"
technical_reasons = [
    "- 알레르기 성분 없음",
    "- 단일 단백질 (닭고기 제외)",
    "- 적정 단백질 함량"
]
user_prefs_text = "모드: 안전 우선, 제외 알레르겐: 닭고기"
rag_context = """
참고 자료 (전문 문서):
1. [veterinary_allergy_4th] 닭고기 알레르기가 있는 반려동물의 경우 단일 단백질 사료를 권장하며...
2. [fediaf_2025] 성견의 경우 체중 관리와 관절 건강을 위해 적정한 단백질 함량이 중요합니다...
"""
```

#### 생성된 프롬프트:
```
펫 정보:
- 이름: 뽀삐
- 종류: 강아지
- 나이 단계: 성견
- 체중: 5.2kg
- 품종: 비글
- 중성화: 완료
- 건강 고민: 비만, 관절
- 알레르기: 닭고기

추천 상품:
- 브랜드: 로얄캐닌
- 상품명: 미니 어덜트

추천 이유 (기술적):
- 알레르기 성분 없음
- 단일 단백질 (닭고기 제외)
- 적정 단백질 함량

사용자 선호도:
모드: 안전 우선, 제외 알레르겐: 닭고기

참고 자료 (전문 문서):
1. [veterinary_allergy_4th] 닭고기 알레르기가 있는 반려동물의 경우 단일 단백질 사료를 권장하며...
2. [fediaf_2025] 성견의 경우 체중 관리와 관절 건강을 위해 적정한 단백질 함량이 중요합니다...

위 정보를 바탕으로, 이 사료가 왜 이 펫에게 추천되는지 자연스럽고 친절하게 설명해줘.
참고 자료가 있으면 그것을 근거로 전문적이고 신뢰할 수 있는 설명을 해줘.
설명은 1-2문장으로 간결하게 작성하고, 펫 이름을 사용해서 친근하게 설명해줘.
사용자 선호도가 있으면 그것도 자연스럽게 언급해줘.
```

---

### 5. LLM 호출 파라미터

```python
response = client.chat.completions.create(
    model=settings.OPENAI_MODEL,  # 기본값: "gpt-4o" 또는 환경변수에서 설정
    temperature=0.7,  # 창의성 약간 높임 (0.0~1.0)
    max_tokens=200,  # 간결한 설명 (최대 200토큰)
    messages=[
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": prompt},
    ],
)
```

**설정값**:
- **temperature**: 0.7 (창의성과 일관성의 균형)
- **max_tokens**: 200 (간결한 설명)
- **model**: `settings.OPENAI_MODEL` (기본값: "gpt-4o")

---

### 6. Confidence Score 계산

```python
def _calculate_confidence_score(explanation, retrieved_chunks):
    if not retrieved_chunks:
        return 50.0  # 문서 없이 생성된 경우 낮은 신뢰도
    
    # 검색된 청크의 유사도 거리를 기반으로 신뢰도 계산
    distances = [chunk.get("distance", 1.0) for chunk in retrieved_chunks]
    avg_distance = sum(distances) / len(distances)
    
    # distance를 신뢰도로 변환
    if avg_distance <= 0.5:
        confidence = 80.0 + (0.5 - avg_distance) * 40.0  # 80~100
    elif avg_distance <= 1.0:
        confidence = 60.0 + (1.0 - avg_distance) * 40.0  # 60~80
    else:
        confidence = 50.0 + max(0, 10.0 - (avg_distance - 1.0) * 10.0)  # 50~60
    
    return min(100.0, max(0.0, confidence))
```

**신뢰도 기준**:
- **80~100점**: distance ≤ 0.5 (매우 유사한 문서)
- **60~80점**: 0.5 < distance ≤ 1.0 (유사한 문서)
- **50~60점**: distance > 1.0 (덜 유사한 문서)
- **50점**: 문서 없음

**Fallback 조건**:
- `confidence_score < 75.0`인 경우 fallback 메시지 사용

---

### 7. Fallback 메시지

```python
def _generate_fallback_explanation(pet_name, technical_reasons):
    if not technical_reasons:
        return f"{pet_name}에게 적합한 사료입니다."
    
    main_reasons = technical_reasons[:3]
    reasons_text = ", ".join(main_reasons)
    return f"{pet_name}에게 {reasons_text} 등의 이유로 추천되는 사료입니다."
```

**예시**:
- "뽀삐에게 알레르기 성분 없음, 단일 단백질 (닭고기 제외), 적정 단백질 함량 등의 이유로 추천되는 사료입니다."

---

## 🔍 RAG 검색 쿼리 생성

```python
query_parts = []
if pet_species:
    query_parts.append(f"{pet_species} 사료")
if health_concerns:
    query_parts.extend(health_concerns)
if allergies:
    query_parts.extend([f"{allergy} 알레르기" for allergy in allergies])
if product_name:
    query_parts.append(product_name)

query_text = " ".join(query_parts) if query_parts else product_name or "반려동물 사료"
```

**예시 쿼리**:
- `"강아지 사료 비만 관절 닭고기 알레르기 로얄캐닌 미니 어덜트"`

---

## 📊 전체 흐름 요약

1. **RAG 검색**: Vector Store에서 관련 문서 청크 검색 (top 5)
2. **컨텍스트 생성**: 최대 3개 청크를 300자로 제한하여 프롬프트에 포함
3. **프롬프트 구성**: 펫 정보 + 상품 정보 + 기술적 이유 + 사용자 선호도 + RAG 컨텍스트
4. **LLM 호출**: System Prompt + User Prompt로 설명 생성
5. **신뢰도 계산**: 검색된 문서의 유사도 거리 기반
6. **Fallback 처리**: 신뢰도 < 75점이면 fallback 메시지 사용

---

## 💡 개선 제안

### 현재 프롬프트의 장점:
- ✅ 펫 정보와 상품 정보를 명확히 구분
- ✅ 기술적 이유와 RAG 컨텍스트를 분리하여 제공
- ✅ 사용자 선호도 고려
- ✅ 간결한 설명 요구 (1-2문장)

### 개선 가능한 부분:
1. **RAG 컨텍스트 형식**: 현재는 단순 나열, 더 구조화된 형식 고려
2. **신뢰도 기준**: 75점 기준이 적절한지 검증 필요
3. **Fallback 메시지**: 더 자연스러운 문장 구조 고려
4. **프롬프트 길이**: 토큰 수 최적화 고려
5. **RAG 컨텍스트 선택**: 유사도가 높은 청크만 선택하도록 필터링 강화
