# RAG 실행 결과 표시 위치

## 📍 RAG 실행 결과가 표시되는 화면

### 1. **홈 화면 (Home Screen)** - 메인 표시 위치 ✅

**파일**: `frontend/lib/features/home/presentation/screens/home_screen.dart`

**위치**: `_buildWhyThisProduct()` 메서드 (Line 485-548)

**표시 방식**:
```dart
Widget _buildWhyThisProduct(petSummary, recommendationItem) {
  // LLM 생성 설명 우선 사용, 없으면 기술적 이유 표시
  final explanation = recommendationItem.explanation; // ← RAG 실행 결과!
  
  return CardContainer(
    child: Column(
      children: [
        Text('왜 이 제품일까요?'),
        // LLM 생성 설명이 있으면 표시
        if (explanation != null && explanation.isNotEmpty) ...[
          Text(
            explanation, // ← RAG로 생성된 자연어 설명 표시
            style: AppTypography.body.copyWith(
              color: const Color(0xFF111827),
              height: 1.5,
            ),
          ),
        ] else if (matchReasons.isNotEmpty) ...[
          // 기술적 이유를 bullet point로 표시 (fallback)
        ],
      ],
    ),
  );
}
```

**호출 위치**: 
- `_buildRecommendationCard()` 메서드 내에서 호출됨
- 추천 카드가 펼쳐진 상태(`_isRecommendationExpanded == true`)일 때 표시

**화면 흐름**:
1. 사용자가 "딱 맞는 사료 보기" 버튼 클릭
2. 추천 결과 로드 완료 후 카드 펼치기
3. 카드 내부에 "왜 이 제품일까요?" 섹션 표시
4. **RAG로 생성된 `explanation` 텍스트가 여기에 표시됨** ✅

---

## 📊 데이터 흐름

```
백엔드 RAG 실행
  ↓
RecommendationExplanationService.generate_explanation()
  ↓
explanation: str (RAG로 생성된 자연어 설명)
  ↓
RecommendationItemDto.explanation: String?
  ↓
API 응답: RecommendationResponseDto.items[].explanation
  ↓
프론트엔드: RecommendationItemDto.explanation
  ↓
HomeScreen._buildWhyThisProduct()
  ↓
화면에 표시: "왜 이 제품일까요?" 섹션 내부 ✅
```

---

## 🎯 표시 조건

### RAG 설명이 표시되는 경우:
- ✅ `explanation != null && explanation.isNotEmpty`
- ✅ 추천 카드가 펼쳐진 상태 (`_isRecommendationExpanded == true`)
- ✅ RAG 실행 성공 (confidence_score >= 75)

### Fallback 표시:
- ❌ `explanation`이 없거나 비어있는 경우
- → `matchReasons` (기술적 이유)를 bullet point로 표시
- → 또는 기본 설명 텍스트 표시

---

## 🔍 확인 방법

### 1. 화면에서 확인
- 홈 화면에서 "딱 맞는 사료 보기" 버튼 클릭
- 추천 카드가 펼쳐지면 "왜 이 제품일까요?" 섹션 확인
- RAG로 생성된 자연어 설명이 표시되는지 확인

### 2. 코드에서 확인
- `home_screen.dart` Line 487: `final explanation = recommendationItem.explanation;`
- `home_screen.dart` Line 504-511: `explanation` 표시 로직

### 3. 백엔드 로그 확인
- RAG 실행 로그: `[RAG] 🎯 RAG 실행 시작: ...`
- 설명 생성 로그: `[Explanation Service] LLM 설명 생성 완료: ...`
- 신뢰도 점수: `(신뢰도: 85.0점)`

---

## 📝 예시

### RAG 실행 결과 예시:
```
"뽀삐에게 딱 맞는 사료입니다. 
현미와 귀리를 사용한 곡물로 소화가 잘 되며, 
닭고기 알레르기가 없어 안전합니다. 
단일 단백질로 구성되어 소화 부담이 적고, 
적정한 단백질 함량으로 체중 관리에 도움이 됩니다."
```

### 화면 표시:
```
┌─────────────────────────────────┐
│ 왜 이 제품일까요?                │
│                                 │
│ 뽀삐에게 딱 맞는 사료입니다.     │
│ 현미와 귀리를 사용한 곡물로...   │
│                                 │
└─────────────────────────────────┘
```

---

## ⚠️ 주의사항

1. **애니메이션 화면에서는 RAG 실행 안 됨**
   - `recommendation_animation_screen.dart`에서는 `skipLlm: true`로 호출
   - 빠른 응답을 위해 LLM 설명 생성 스킵

2. **추천 상세 화면에서는 표시 안 됨**
   - `recommendation_detail_screen.dart`에는 `explanation` 표시 로직 없음
   - 대신 `matchReasons`를 기반으로 섹션별로 분리하여 표시

3. **신뢰도가 낮으면 Fallback 사용**
   - `confidence_score < 75`인 경우 fallback 메시지 사용
   - RAG 컨텍스트가 부족한 경우
