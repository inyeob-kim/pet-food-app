# Parsed JSON 필드 비교 분석

## 현재 AI가 생성하는 필드 vs 설계에서 요구하는 필드

### ✅ 현재 생성 중인 필드 (기본 필드)

| 필드명 | 타입 | 설명 | 설계 요구사항 |
|--------|------|------|--------------|
| `raw_text` | string | 원재료 원문 | ✅ 필요 |
| `ingredients_ordered` | array | 성분 순서 배열 | ✅ 필요 |
| `first_five` | array | 첫 5개 성분 | ✅ 필요 |
| `animal_proteins` | array | 동물성 단백질 | ✅ 필요 |
| `plant_proteins` | array | 식물성 단백질 | ✅ 필요 |
| `grains` | array | 곡물 리스트 | ✅ 필요 |
| `potential_allergens` | array | 알레르겐 코드 배열 | ✅ 필요 |
| `additives` | array | 첨가물 리스트 | ✅ 필요 |
| `is_grain_free` | boolean | 무곡물 여부 | ✅ 필요 |
| `first_ingredient_is_meat` | boolean | 첫 성분이 고기인지 | ✅ 필요 |
| `protein_source_quality` | string | "low"\|"medium"\|"high" | ✅ 필요 |
| `quality_score` | number | 0-100 품질 점수 | ✅ 필요 |
| `notes` | string | 한 줄 요약 | ✅ 필요 |

### ❌ 설계에서 요구하지만 현재 생성하지 않는 필드 (확장 필드)

| 필드명 | 타입 | 설명 | 설계 영향도 | 대안 |
|--------|------|------|------------|------|
| `life_stage` | string | "puppy"\|"adult"\|"senior"\|"all_life_stages" | 🔴 높음 | `product_name` 키워드 매칭 (fallback) |
| `benefits_tags` | array | ["joint_support", "weight_management", ...] | 🔴 높음 | `notes` 또는 `product_name` 키워드 매칭 (fallback) |
| `nutritional_profile` | object | {kcal_per_kg, protein_min, ...} | 🟡 중간 | `ProductNutritionFacts` 테이블에서 조회 가능 |
| `allergen_confidence` | object | {"CHICKEN": "high", ...} | 🟡 중간 | 없으면 penalty 적용 안 함 (기본 동작) |

---

## 상세 분석

### 1. `life_stage` 필드 (🔴 높은 우선순위)

**설계에서의 역할:**
- 나이 단계 매칭의 **1순위** 데이터 소스
- `parsed.life_stage`가 있으면 정확한 매칭 가능
- 없으면 `product_name` 키워드 매칭으로 fallback (정확도 낮음)

**현재 상태:**
- ❌ AI가 생성하지 않음
- ⚠️ `product_name`에서 추론 가능하지만 정확도 낮음

**영향:**
- 나이 단계 매칭 점수 (25점 만점)의 정확도가 낮아짐
- `all_life_stages` 사료를 제대로 인식하지 못할 수 있음

**권장 조치:**
```python
# USER_PROMPT_TEMPLATE에 추가 필요
"life_stage": "puppy" | "adult" | "senior" | "all_life_stages" | null,
```

---

### 2. `benefits_tags` 필드 (🔴 높은 우선순위)

**설계에서의 역할:**
- 건강 고민 매칭의 **1순위** 데이터 소스
- `benefits_tags` 매칭 시 가중치 **1.5배** 적용
- 없으면 키워드 매칭으로 fallback (정확도 낮음)

**현재 상태:**
- ❌ AI가 생성하지 않음
- ⚠️ `notes`나 `product_name`에서 키워드 추론 가능하지만 정확도 낮음

**영향:**
- 건강 고민 매칭 점수 (30점 만점)의 정확도가 낮아짐
- 태그 기반 매칭의 1.5배 가중치 혜택을 받지 못함

**권장 조치:**
```python
# USER_PROMPT_TEMPLATE에 추가 필요
"benefits_tags": [
    "joint_support",      // 관절 지원
    "weight_management",  // 체중 관리
    "hypoallergenic",     // 저알레르기
    "urinary",            // 요로 건강
    "digestive",          // 소화 건강
    "dental",             // 구강 건강
    "skin_coat",          // 피모 건강
    "immune_support"      // 면역 지원
],
```

---

### 3. `nutritional_profile` 필드 (🟡 중간 우선순위)

**설계에서의 역할:**
- 영양 적합성 점수 계산 (20점 만점)
- DER 기반 하루 급여량 적합도 평가
- `kcal_per_kg` 또는 `kcal_per_100g` 필요

**현재 상태:**
- ❌ `parsed` JSON에 없음
- ✅ `ProductNutritionFacts` 테이블에 `kcal_per_100g` 존재
- ⚠️ 추천 로직에서 `nutrition_facts` 테이블 조인 필요

**영향:**
- `parsed.nutritional_profile.kcal_per_kg`가 없으면 `nutrition_facts.kcal_per_100g` 사용 (fallback)
- 구현 복잡도 약간 증가 (테이블 조인 필요)

**권장 조치:**
- 옵션 1: AI가 생성하도록 추가 (권장)
- 옵션 2: 추천 로직에서 `nutrition_facts` 테이블 조인 (현재 가능)

---

### 4. `allergen_confidence` 필드 (🟡 중간 우선순위)

**설계에서의 역할:**
- High confidence 알레르겐에 -20점 penalty 적용
- 펫 알레르기 목록에 없어도 위험 알레르겐 감지

**현재 상태:**
- ❌ AI가 생성하지 않음
- ⚠️ 없으면 penalty 적용 안 함 (기본 동작)

**영향:**
- High confidence 알레르겐 penalty 기능이 작동하지 않음
- 안전성 점수 계산의 정확도가 약간 낮아짐

**권장 조치:**
```python
# USER_PROMPT_TEMPLATE에 추가 필요 (선택적)
"allergen_confidence": {
    "CHICKEN": "high" | "medium" | "low",
    "CORN": "medium",
    ...
},
```

---

## 권장 조치사항

### 즉시 추가 권장 (Phase 2 구현 전)

1. **`life_stage` 필드 추가** 🔴
   - 나이 단계 매칭 정확도 향상
   - `all_life_stages` 사료 인식 가능

2. **`benefits_tags` 필드 추가** 🔴
   - 건강 고민 매칭 정확도 향상
   - 1.5배 가중치 혜택 적용 가능

### 선택적 추가 (향후 개선)

3. **`nutritional_profile` 필드 추가** 🟡
   - `parsed` JSON에 포함되면 추천 로직 단순화
   - 현재는 `nutrition_facts` 테이블 조인으로 해결 가능

4. **`allergen_confidence` 필드 추가** 🟡
   - High confidence 알레르겐 penalty 기능 활성화
   - 없어도 기본 동작 가능

---

## 수정이 필요한 파일

### `backend/app/services/ingredient_ai_service.py`

**현재 USER_PROMPT_TEMPLATE:**
```python
USER_PROMPT_TEMPLATE = """...
반환 형식(JSON만, 설명 금지):
{{
  "raw_text": "...",
  "ingredients_ordered": [],
  ...
  "notes": "한 줄 요약"
}}"""
```

**수정 후 (권장):**
```python
USER_PROMPT_TEMPLATE = """...
반환 형식(JSON만, 설명 금지):
{{
  "raw_text": "...",
  "ingredients_ordered": [],
  "first_five": [],
  "animal_proteins": [],
  "plant_proteins": [],
  "grains": [],
  "potential_allergens": [],
  "additives": [],
  "is_grain_free": true,
  "first_ingredient_is_meat": true,
  "protein_source_quality": "low|medium|high",
  "quality_score": 0-100,
  "notes": "한 줄 요약",
  
  // 추가 필드 (추천 시스템 강화)
  "life_stage": "puppy" | "adult" | "senior" | "all_life_stages" | null,
  "benefits_tags": ["joint_support", "weight_management", "hypoallergenic", ...],
  "nutritional_profile": {
    "kcal_per_kg": 3500,
    "kcal_per_100g": 350,
    "protein_min": 25.0,
    "fat_min": 12.0,
    "fiber_max": 5.0
  },
  "allergen_confidence": {
    "CHICKEN": "high" | "medium" | "low",
    "CORN": "medium",
    ...
  }
}}"""
```

---

## Fallback 전략 (현재 구현 가능)

설계 문서에 따르면, 확장 필드가 없어도 fallback으로 동작 가능:

1. **`life_stage` 없음** → `product_name` 키워드 매칭
2. **`benefits_tags` 없음** → `notes` 또는 `product_name` 키워드 매칭
3. **`nutritional_profile` 없음** → `ProductNutritionFacts` 테이블 조인
4. **`allergen_confidence` 없음** → Penalty 적용 안 함 (기본 동작)

**결론:** 현재 필드만으로도 기본 추천 시스템은 동작 가능하지만, 확장 필드를 추가하면 정확도가 크게 향상됩니다.
