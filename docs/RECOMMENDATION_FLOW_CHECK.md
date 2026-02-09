# 추천 시스템 흐름 확인 문서

## 전체 흐름 요약

### 1. 홈화면 진입 시
```
홈화면 진입
  ↓
HomeController.initialize() 호출
  ↓
1. Primary Pet 조회
2. 추천 자동 로드 (_loadRecommendations)
  ↓
GET /api/v1/products/recommendations?pet_id={pet_id}
  ↓
백엔드: ProductService.get_recommendations()
  ↓
- 펫 프로필 조회
- parsed JSON이 있는 활성 상품 필터링
- 각 상품 스코링 (룰베이스)
- LLM으로 추천 이유 설명 생성
- 상위 10개 반환
  ↓
프론트엔드: 추천 데이터 표시 준비 완료
```

### 2. "딱 맞는 사료 보기" 버튼 클릭 시
```
버튼 클릭
  ↓
_toggleRecommendation() 호출
  ↓
추천이 없으면?
  → refreshRecommendations() 호출 (새로고침)
  → 추천 로드 중 표시
  ↓
추천이 있으면?
  → _isRecommendationExpanded 토글
  → 추천 결과 펼치기/접기
```

### 3. 추천 결과 표시
```
_isRecommendationExpanded == true
  ↓
_buildRecommendationSection() 호출
  ↓
1. 추천 근거 섹션 (_buildRecommendationBasis)
2. 추천 사료 요약 블록 (_buildProductSummary)
3. 적합도 카드 (_buildMatchScoreCard)
4. "왜 이 제품?" 설명 섹션 (_buildWhyThisProduct)
   - LLM 생성 explanation 우선 표시
   - 없으면 matchReasons를 bullet point로 표시
   - 둘 다 없으면 기본 설명 표시
```

---

## 구현 확인 사항

### ✅ 백엔드
- [x] RecommendationScoringService 생성 (룰베이스 스코링)
- [x] RecommendationExplanationService 생성 (LLM 설명 생성)
- [x] ProductService.get_recommendations() 구현
- [x] RecommendationItem 스키마에 match_reasons, explanation 필드 추가

### ✅ 프론트엔드
- [x] RecommendationItemDto에 matchReasons, explanation 필드 추가
- [x] _buildWhyThisProduct 함수에 explanation 표시 로직 추가
- [x] 버튼 클릭 시 추천 새로고침 로직 추가
- [x] 로딩 상태 표시 개선

---

## API 호출 확인

### 엔드포인트
```
GET /api/v1/products/recommendations?pet_id={pet_id}
```

### 요청 예시
```bash
curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id=63d73fba-0bbb-4872-9b65-b2f2b59f1e59" \
  -H "X-Device-UID: 63d73fba-0bbb-4872-9b65-b2f2b59f1e59"
```

### 응답 예시
```json
{
  "pet_id": "63d73fba-0bbb-4872-9b65-b2f2b59f1e59",
  "items": [
    {
      "product": {
        "id": "...",
        "brand_name": "로얄캐닌",
        "product_name": "미니 어덜트",
        "size_label": "3kg",
        "is_active": true
      },
      "offer_merchant": "COUPANG",
      "current_price": 0,
      "avg_price": 0,
      "delta_percent": null,
      "is_new_low": false,
      "match_reasons": [
        "알레르기 안전",
        "나이 단계 적합",
        "건강 고민 매칭"
      ],
      "explanation": "까불이에게 안전하고, 성견 단계에 적합하며, 관절 건강을 고려한 사료입니다."
    }
  ]
}
```

---

## 화면 표시 확인

### 1. 버튼 상태
- ✅ 추천 로드 중: 로딩 스피너 표시
- ✅ 추천 있음: "딱 맞는 사료 보기" / "추천 사료 접기"
- ✅ 추천 없음: "딱 맞는 사료 보기" (클릭 시 새로고침)

### 2. 추천 결과 표시
- ✅ 추천 근거 섹션: 체중, 나이 단계, 건강 상태 태그
- ✅ 추천 사료 요약: 브랜드명, 상품명, 가격
- ✅ 적합도 카드: 매칭 점수 표시
- ✅ "왜 이 제품?" 설명:
  - LLM 생성 explanation (자연어) 우선 표시
  - 없으면 matchReasons (기술적 이유) bullet point 표시
  - 둘 다 없으면 기본 설명 표시

---

## 테스트 시나리오

### 시나리오 1: 정상 추천
1. 홈화면 진입 → 추천 자동 로드
2. "딱 맞는 사료 보기" 버튼 클릭
3. 추천 결과 펼쳐짐
4. explanation 필드가 화면에 표시됨

### 시나리오 2: 추천 없음
1. 홈화면 진입 → 추천 없음
2. "딱 맞는 사료 보기" 버튼 클릭
3. 추천 새로고침 시작
4. 로딩 중 표시
5. 추천 결과 또는 "추천 상품이 없습니다" 메시지

### 시나리오 3: LLM 실패
1. 추천 로드 완료
2. explanation이 null인 경우
3. matchReasons를 bullet point로 표시

---

## 확인 필요 사항

### 1. 데이터베이스
- [ ] parsed JSON이 적재된 상품이 있는지 확인
- [ ] 펫 프로필이 제대로 조회되는지 확인
- [ ] 알레르기 정보가 제대로 조회되는지 확인

### 2. API 응답
- [ ] 추천 API가 정상 응답하는지 확인
- [ ] explanation 필드가 포함되는지 확인
- [ ] match_reasons 필드가 포함되는지 확인

### 3. 화면 표시
- [ ] explanation이 자연스럽게 표시되는지 확인
- [ ] matchReasons fallback이 제대로 동작하는지 확인
- [ ] 버튼 클릭 시 추천이 펼쳐지는지 확인

---

## 디버깅 팁

### 백엔드 로그 확인
```bash
# 백엔드 로그에서 확인할 내용
[ProductService] 추천 요청: pet_id=...
[ProductService] 펫 프로필: ...
[ProductService] parsed JSON이 있는 상품 수: ...
[ProductService] 스코링 완료: ...개 상품
[Explanation Service] LLM 설명 생성 시작: ...
[ProductService] 추천 완료: ...개 상품 반환
```

### 프론트엔드 로그 확인
```dart
// HomeController에서 확인할 내용
[HomeController] initialize() 시작
[HomeController] Primary Pet 조회 결과: ...
```

### API 테스트
```bash
# 추천 API 직접 호출 테스트
curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id={pet_id}" \
  -H "X-Device-UID: {device_uid}"
```

---

## 예상 문제 및 해결

### 문제 1: 추천이 없음
**원인**: parsed JSON이 적재된 상품이 없음
**해결**: 관리자 페이지에서 AI 분석 버튼으로 parsed JSON 적재

### 문제 2: explanation이 null
**원인**: LLM 호출 실패 또는 OpenAI API 키 미설정
**해결**: matchReasons fallback으로 표시됨 (기능 정상 동작)

### 문제 3: 추천이 너무 느림
**원인**: LLM 호출이 느림 (각 상품마다 호출)
**해결**: 향후 배치 처리 또는 캐싱 고려

---

## 다음 단계

1. ✅ 룰베이스 추천 시스템 구현 완료
2. ✅ LLM 설명 생성 기능 추가 완료
3. ⏳ 실제 데이터로 테스트 필요
4. ⏳ 가격 정보 연동 (PriceSnapshot)
5. ⏳ 성능 최적화 (캐싱, 배치 처리)
