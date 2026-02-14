# RAG 호출 경로 분석

## 📍 전체 호출 흐름

```
1. 사용자 액션
   └─ HomeScreen에서 "딱 맞는 사료 보기" 버튼 클릭
      ↓
2. 프론트엔드 - 화면 레이어
   └─ home_screen.dart: _toggleRecommendation() (Line 115)
      ↓
3. 프론트엔드 - 컨트롤러 레이어
   └─ home_controller.dart: loadRecommendations() (Line 189)
      └─ _loadRecommendations() (Line 146)
         ↓
4. 프론트엔드 - 데이터 레이어
   └─ product_repository.dart: getRecommendations(petId, skipLlm: false) (Line 75)
      └─ API 호출: GET /api/v1/products/recommendations?pet_id={uuid}&skip_llm=false
      ↓
5. 백엔드 - API 레이어
   └─ products.py: get_recommendations() (Line 25)
      └─ ProductService.get_recommendations(pet_id, db, skip_llm=False)
      ↓
6. 백엔드 - 서비스 레이어
   └─ product_service.py: get_recommendations() (Line 530-546)
      └─ 상위 10개 상품 루프에서:
         if not skip_llm:  # skip_llm=False이므로 실행됨 ✅
            ↓
7. RAG 서비스 호출
   └─ recommendation_explanation_service.py: generate_explanation() (Line 202)
      └─ _retrieve_relevant_chunks() 호출 (Line 237) ← RAG 실행! 🎯
         └─ Chroma Vector Store에서 문서 검색
      └─ LLM에 RAG 컨텍스트와 함께 설명 생성 요청
```

## 🔍 각 단계별 상세

### 1. 프론트엔드 - 버튼 클릭
**파일**: `frontend/lib/features/home/presentation/screens/home_screen.dart`
**위치**: Line 115, Line 1424

```dart
void _toggleRecommendation({bool forceRefresh = false}) {
  // ...
  ref.read(homeControllerProvider.notifier).loadRecommendations(force: forceRefresh);
}
```

### 2. 프론트엔드 - 컨트롤러
**파일**: `frontend/lib/features/home/presentation/controllers/home_controller.dart`
**위치**: Line 146-153

```dart
Future<void> _loadRecommendations(String petId, {bool force = false}) async {
  // ⚠️ skipLlm 파라미터를 전달하지 않음 → 기본값 false 사용
  final recommendations = await _productRepository.getRecommendations(petId);
  // skipLlm: false이므로 RAG 실행됨 ✅
}
```

### 3. 프론트엔드 - Repository
**파일**: `frontend/lib/data/repositories/product_repository.dart`
**위치**: Line 75-82

```dart
Future<RecommendationResponseDto> getRecommendations(String petId, {bool skipLlm = false}) async {
  // skipLlm 기본값: false
  final response = await _apiClient.get(
    Endpoints.productRecommendations,
    queryParameters: {'pet_id': petId, 'skip_llm': skipLlm}, // skip_llm=false
  );
}
```

### 4. 백엔드 - API 엔드포인트
**파일**: `backend/app/api/v1/products.py`
**위치**: Line 25-36

```python
@router.get("/recommendations")
async def get_recommendations(
    pet_id: UUID,
    skip_llm: bool = Query(False, ...),  # 기본값 False
    db: AsyncSession = Depends(get_db)
):
    result = await ProductService.get_recommendations(pet_id, db, skip_llm=skip_llm)
    # skip_llm=False이므로 RAG 실행됨 ✅
```

### 5. 백엔드 - ProductService
**파일**: `backend/app/services/product_service.py`
**위치**: Line 530-546

```python
# 상위 10개 상품 루프
for idx, (product, total_score, safety_score, fitness_score, reasons) in enumerate(top_products, 1):
    explanation = None
    if not skip_llm:  # skip_llm=False이므로 실행됨 ✅
        explanation = await RecommendationExplanationService.generate_explanation(
            pet_name=pet_summary.name,
            pet_species=pet_summary.species,
            # ... 기타 파라미터들
        )
```

### 6. 백엔드 - RAG 서비스 실행
**파일**: `backend/app/services/recommendation_explanation_service.py`
**위치**: Line 237-243

```python
async def generate_explanation(...) -> str:
    # RAG: 관련 문서 검색 🎯
    retrieved_chunks = await RecommendationExplanationService._retrieve_relevant_chunks(
        pet_species=pet_species,
        health_concerns=health_concerns,
        allergies=allergies,
        product_name=product_name,
        top_k=5
    )
    # Vector Store에서 문서 검색 완료
    # ...
```

## ✅ RAG 실행 확인 방법

### 1. 백엔드 로그 확인
RAG가 실행되면 다음과 같은 로그가 출력됩니다:

```
[RAG] Retrieving top 5 chunks for pet_species=DOG, health_concerns=[...]
[RAG] 쿼리: DOG 사료 비만 ...
[RAG] 5개 관련 문서 청크 검색 완료
[Explanation Service] LLM 설명 생성 완료: ... (신뢰도: 85.0점)
```

### 2. 프론트엔드 로그 확인
```
[ProductRepository] 🌐 API 호출 시작: GET .../recommendations?pet_id=...&skip_llm=false
[HomeController] ✅ 추천 데이터 로드 완료: 3개 상품
```

### 3. 실제 호출 여부 확인
- 백엔드 서버 로그에서 `[RAG]` 키워드 검색
- `_retrieve_relevant_chunks()` 함수에 로그 추가하여 확인

## ⚠️ 현재 상태

**코드상으로는 RAG가 실행되어야 합니다:**
- `skipLlm` 파라미터가 전달되지 않아 기본값 `false` 사용
- `skip_llm=false`이면 RAG 실행됨

**만약 RAG가 실행되지 않는다면:**
1. Vector Store가 없거나 접근 불가능한 경우
2. ChromaDB가 설치되지 않은 경우
3. 에러가 발생했지만 로그에 나타나지 않은 경우

## 🔧 디버깅 방법

백엔드 로그에서 다음을 확인하세요:
- `[RAG]` 로그가 있는지
- `[Explanation Service]` 로그가 있는지
- 에러 로그가 있는지
