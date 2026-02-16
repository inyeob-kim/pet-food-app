# RAG 프롬프트 데이터 출처 분석

## ✅ 네, 정확히 펫 현재 프로필과 추천된 사료 정보 기준으로 답변합니다

---

## 📊 프롬프트에 포함되는 데이터 출처

### 1. **펫 프로필 정보** (DB에서 조회)

**출처**: `ProductService._build_pet_summary(pet, db)` → `PetSummaryResponse`

```python
# product_service.py Line 230
pet_summary = await ProductService._build_pet_summary(pet, db)

# generate_explanation 호출 시 (Line 534-542)
explanation = await RecommendationExplanationService.generate_explanation(
    pet_name=pet_summary.name,              # ✅ DB에서 조회한 실제 펫 이름
    pet_species=pet_summary.species,        # ✅ DB에서 조회한 실제 종류 (DOG/CAT)
    pet_age_stage=pet_summary.age_stage,    # ✅ DB에서 조회한 실제 나이 단계 (PUPPY/ADULT/SENIOR)
    pet_weight=pet_summary.weight_kg,       # ✅ DB에서 조회한 실제 체중 (kg)
    pet_breed=pet_summary.breed_code,       # ✅ DB에서 조회한 실제 품종 코드
    pet_neutered=pet_summary.is_neutered,   # ✅ DB에서 조회한 실제 중성화 여부
    health_concerns=pet_summary.health_concerns or [],  # ✅ DB에서 조회한 실제 건강 고민 리스트
    allergies=pet_summary.food_allergies or [],         # ✅ DB에서 조회한 실제 알레르기 리스트
    ...
)
```

**데이터 예시**:
- 이름: "뽀삐" (DB의 `Pet.name`)
- 종류: "DOG" (DB의 `Pet.species`)
- 나이 단계: "ADULT" (DB의 `Pet.age_stage` 또는 계산된 값)
- 체중: 5.2kg (DB의 `Pet.weight_kg`)
- 품종: "BEAGLE" (DB의 `Pet.breed_code`)
- 중성화: True (DB의 `Pet.is_neutered`)
- 건강 고민: ["OBESITY", "JOINT"] (DB의 `Pet.health_concerns`)
- 알레르기: ["CHICKEN"] (DB의 `Pet.food_allergies`)

---

### 2. **추천된 사료 정보** (DB에서 조회)

**출처**: `Product` 모델 (DB에서 조회한 실제 상품 데이터)

```python
# product_service.py Line 496-544
for idx, (product, total_score, safety_score, fitness_score, reasons) in enumerate(top_products, 1):
    explanation = await RecommendationExplanationService.generate_explanation(
        ...
        brand_name=product.brand_name,      # ✅ DB에서 조회한 실제 브랜드명
        product_name=product.product_name,  # ✅ DB에서 조회한 실제 상품명
        ...
    )
```

**데이터 예시**:
- 브랜드: "로얄캐닌" (DB의 `Product.brand_name`)
- 상품명: "미니 어덜트 3kg" (DB의 `Product.product_name`)

---

### 3. **기술적 추천 이유** (펫 프로필과 상품 비교 분석 결과)

**출처**: `RecommendationScoringService`의 점수 계산 결과

```python
# product_service.py Line 362-377
safety_score, safety_reasons = await RecommendationScoringService.calculate_safety_score(
    pet_summary, product, parsed, ingredients_text, user_prefs, db, harmful_ingredients_cache
)

fitness_score, fitness_reasons, age_penalty = RecommendationScoringService.calculate_fitness_score(
    pet_summary, product, parsed, product.nutrition_facts, user_prefs
)

# Line 440
all_reasons = safety_reasons + fitness_reasons  # 두 리스트 합침

# Line 545
technical_reasons=reasons  # 이 reasons가 프롬프트에 포함됨
```

**안전성 이유 예시** (`safety_reasons`):
- "알레르기 안전"
- "유해 성분 없음"
- "첫 성분이 고기"
- "높은 품질 점수"

**적합성 이유 예시** (`fitness_reasons`):
- "강아지용 사료"
- "비만 건강 고민 매칭 (태그)"
- "관절 지원 (대형견 적합)"
- "적정 급여량 범위"

**이유들은 모두**:
- ✅ 펫 프로필 (`pet_summary`)과 상품 정보 (`product`)를 비교하여 계산됨
- ✅ 실제 상품의 성분 정보 (`parsed`, `ingredients_text`)를 분석하여 생성됨
- ✅ 펫의 알레르기, 건강 고민, 나이, 품종 등을 고려하여 생성됨

---

### 4. **사용자 선호도** (DB에서 조회 또는 기본값)

**출처**: `UserRecoPrefs` 모델 (DB에서 조회)

```python
# product_service.py Line 234-253
user_prefs_result = await db.execute(
    select(UserRecoPrefs).where(UserRecoPrefs.user_id == user_id)
)
user_prefs_obj = user_prefs_result.scalars().first()

if user_prefs_obj and user_prefs_obj.prefs:
    user_prefs = {**default_prefs, **user_prefs_obj.prefs}
else:
    user_prefs = default_prefs  # 기본값 사용

# Line 546
user_prefs=user_prefs  # 프롬프트에 포함됨
```

**포함 정보**:
- `weights_preset`: "SAFE" / "BALANCED" / "VALUE"
- `hard_exclude_allergens`: 강제 제외 알레르겐 리스트
- `soft_avoid_ingredients`: 피하고 싶은 성분 리스트
- `max_price_per_kg`: 최대 가격 제한

---

### 5. **RAG 컨텍스트** (Vector Store에서 검색)

**출처**: Chroma Vector Store (임베딩된 전문 문서)

```python
# recommendation_explanation_service.py Line 237-244
retrieved_chunks = await RecommendationExplanationService._retrieve_relevant_chunks(
    pet_species=pet_species,        # 펫 종류 기반 검색
    health_concerns=health_concerns, # 건강 고민 기반 검색
    allergies=allergies,             # 알레르기 기반 검색
    product_name=product_name,      # 상품명 기반 검색
    top_k=5
)
```

**검색 쿼리 예시**:
- `"강아지 사료 비만 관절 닭고기 알레르기 로얄캐닌 미니 어덜트"`

**검색 결과**:
- Veterinary Allergy 4th Edition 관련 청크
- FEDIAF 2025 Nutritional Guidelines 관련 청크
- AAFCO 2025 Official Publication 관련 청크

---

## 🔍 데이터 흐름 요약

```
1. 펫 프로필 조회 (DB)
   └─ Pet 테이블에서 pet_id로 조회
   └─ PetSummaryResponse 생성
      ↓
2. 상품 목록 조회 (DB)
   └─ Product 테이블에서 활성 상품 조회
   └─ 각 상품의 ingredient_profile, nutrition_facts 포함
      ↓
3. 스코링 (펫 프로필 vs 각 상품)
   └─ calculate_safety_score() → safety_reasons 생성
   └─ calculate_fitness_score() → fitness_reasons 생성
   └─ all_reasons = safety_reasons + fitness_reasons
      ↓
4. 상위 10개 선택
   └─ 총점 기준 정렬
   └─ top_products = scored_products[:10]
      ↓
5. RAG 검색 (각 상품별)
   └─ 펫 프로필 + 상품명으로 Vector Store 검색
   └─ 관련 문서 청크 5개 검색
      ↓
6. 프롬프트 구성
   └─ 펫 프로필 정보 (DB)
   └─ 상품 정보 (DB)
   └─ 기술적 이유 (펫 vs 상품 비교 결과)
   └─ 사용자 선호도 (DB)
   └─ RAG 컨텍스트 (Vector Store)
      ↓
7. LLM 설명 생성
   └─ 모든 정보를 종합하여 자연어 설명 생성
```

---

## ✅ 결론

**네, 정확히 펫 현재 프로필과 추천된 사료 정보 기준으로 답변합니다.**

1. **펫 프로필**: DB에서 조회한 실제 펫 정보 사용
2. **추천된 사료**: DB에서 조회한 실제 상품 정보 사용
3. **기술적 이유**: 펫 프로필과 상품을 비교 분석하여 계산된 실제 이유 사용
4. **사용자 선호도**: DB에서 조회한 실제 사용자 설정 사용
5. **RAG 컨텍스트**: 펫 프로필과 상품 정보를 기반으로 검색된 전문 문서 사용

**모든 데이터는 실제 DB 데이터와 계산 결과를 기반으로 하며, 하드코딩된 값이 아닙니다.**
