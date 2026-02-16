# 현재 캐시 저장 데이터 상세 설명

## 1. Redis 캐시 (L1 Cache) - 메모리 기반

### 1.1 추천 결과 캐시 (활성화됨 ✅)

**캐시 키**: `petfood:rec:result:{pet_id}`

**저장 데이터**: `RecommendationResponse` 전체 객체 (JSON)

**데이터 구조**:
```json
{
  "pet_id": "12e923a5-e8f4-4835-afe3-2a06a8a9160c",
  "items": [
    {
      "product": {
        "id": "product-uuid",
        "brand_name": "브랜드명",
        "product_name": "상품명",
        "species": "DOG",
        ...
      },
      "match_score": 95.5,
      "safety_score": 98.0,
      "fitness_score": 93.0,
      "match_reasons": ["알레르기 안전", "체중 관리 적합", ...],
      "current_price": 50000,
      "avg_price": 55000,
      "delta_percent": -9.1,
      "is_new_low": false,
      "offer_merchant": "COUPANG",
      "technical_explanation": null,
      "expert_explanation": null,
      "animation_explanation": null,
      "safety_badges": null,
      "confidence_score": 75.0
    },
    ...
  ],
  "is_cached": true,
  "last_recommended_at": "2024-01-15T10:30:00Z",
  "message": null
}
```

**TTL**: 7일 (604,800초)

**저장 시점**:
- 새 추천 계산 완료 후
- PostgreSQL에서 캐시 조회 후 (Redis에 없을 때)

**조회 시점**:
- `GET /api/v1/products/recommendations?pet_id={pet_id}` 호출 시
- `force_refresh=false`일 때만

**무효화 시점**:
- 펫 프로필 업데이트 시
- 수동 캐시 삭제 API 호출 시
- 전체 캐시 삭제 API 호출 시

---

### 1.2 펫 프로필 캐시 (구현됨, 미사용 ⚠️)

**캐시 키**: `petfood:pet:summary:{pet_id}`

**저장 데이터**: `dict` 형태의 펫 프로필 정보

**TTL**: 1시간 (3,600초)

**현재 상태**: 메서드는 구현되어 있지만 실제로 저장/조회하는 코드는 없음

---

### 1.3 상품 맞춤 점수 캐시 (키만 정의, 미구현 ❌)

**캐시 키**: `petfood:product:match:{product_id}:{pet_id}`

**저장 데이터**: `ProductMatchScoreResponse`

**TTL**: 1시간 (3,600초)

**현재 상태**: 키만 정의되어 있고 실제 저장/조회 로직은 없음

---

## 2. PostgreSQL 캐시 (L2 Cache) - 영구 저장

### 2.1 RecommendationRun 테이블

**저장 데이터**: 추천 실행 로그

**테이블 구조**:
```sql
CREATE TABLE recommendation_runs (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    pet_id UUID NOT NULL,
    strategy VARCHAR NOT NULL,  -- 'RULE_V1', 'RULE_V2', 'ML_V1'
    context JSONB NOT NULL,      -- 당시 펫/필터/선호/제외 알레르겐 등 스냅샷
    created_at TIMESTAMP NOT NULL
);
```

**저장 내용**:
- `pet_id`: 추천을 받은 펫 ID
- `user_id`: 사용자 ID
- `strategy`: 추천 전략 (현재는 'RULE_V1')
- `context`: 추천 당시의 펫 프로필 스냅샷 (JSONB)
- `created_at`: 추천 실행 시각

**TTL**: 7일 (created_at 기준, 코드에서 자동 삭제하지 않음)

---

### 2.2 RecommendationItem 테이블

**저장 데이터**: 추천된 각 상품의 상세 정보

**테이블 구조**:
```sql
CREATE TABLE recommendation_items (
    run_id UUID NOT NULL,
    product_id UUID NOT NULL,
    rank INTEGER NOT NULL,           -- 순위 (1, 2, 3, ...)
    score NUMERIC(8, 4) NOT NULL,     -- 총점 (0.0 ~ 100.0)
    reasons JSONB NOT NULL,          -- 추천 이유 리스트
    score_components JSONB,          -- 세부 점수 분해
    PRIMARY KEY (run_id, product_id)
);
```

**저장 내용**:
- `run_id`: RecommendationRun의 ID (외래키)
- `product_id`: 추천된 상품 ID
- `rank`: 순위 (1위, 2위, 3위...)
- `score`: 총점 (예: 95.5)
- `reasons`: 추천 이유 배열 (예: `["알레르기 안전", "체중 관리 적합"]`)
- `score_components`: 세부 점수 (예: `{"safety_score": 98.0, "fitness_score": 93.0}`)

**TTL**: RecommendationRun과 함께 관리 (7일)

---

## 3. 캐시 저장 흐름

### 3.1 추천 요청 시

```
1. GET /api/v1/products/recommendations?pet_id={pet_id}
   ↓
2. Redis 조회 (petfood:rec:result:{pet_id})
   ├─ Hit: 즉시 반환 (1-5ms)
   └─ Miss: PostgreSQL 조회
       ├─ Hit: RecommendationRun + RecommendationItem 조회
       │   → RecommendationResponse 생성
       │   → Redis에 저장 (7일 TTL)
       │   → 반환
       └─ Miss: 새로 계산
           → RecommendationResponse 생성
           → Redis에 저장 (7일 TTL)
           → PostgreSQL에 저장 (RecommendationRun + RecommendationItem)
           → 반환
```

### 3.2 실제 저장되는 데이터 예시

**Redis에 저장되는 JSON**:
```json
{
  "pet_id": "12e923a5-e8f4-4835-afe3-2a06a8a9160c",
  "items": [
    {
      "product": {
        "id": "abc-123",
        "brand_name": "로얄캐닌",
        "product_name": "로얄캐닌 미니 어덜트",
        "species": "DOG",
        "size_label": "2kg",
        "is_active": true
      },
      "match_score": 95.5,
      "safety_score": 98.0,
      "fitness_score": 93.0,
      "match_reasons": ["알레르기 안전", "체중 관리 적합"],
      "current_price": 50000,
      "avg_price": 55000,
      "delta_percent": -9.1,
      "is_new_low": false,
      "offer_merchant": "COUPANG",
      "technical_explanation": null,
      "expert_explanation": null,
      "animation_explanation": null,
      "safety_badges": null,
      "confidence_score": 75.0
    }
  ],
  "is_cached": true,
  "last_recommended_at": "2024-01-15T10:30:00Z",
  "message": null
}
```

**PostgreSQL에 저장되는 데이터**:

**recommendation_runs**:
```sql
id: a1b2c3d4-...
user_id: 00000000-0000-0000-0000-000000000000
pet_id: 12e923a5-e8f4-4835-afe3-2a06a8a9160c
strategy: RULE_V1
context: {
  "pet_summary": {...},
  "user_prefs": {...},
  "excluded_allergens": [...]
}
created_at: 2024-01-15 10:30:00
```

**recommendation_items**:
```sql
run_id: a1b2c3d4-...
product_id: abc-123
rank: 1
score: 95.5
reasons: ["알레르기 안전", "체중 관리 적합"]
score_components: {
  "safety_score": 98.0,
  "fitness_score": 93.0,
  "age_penalty": 0.0,
  "total_score": 95.5
}
```

---

## 4. 캐시 무효화

### 4.1 자동 무효화

**펫 프로필 업데이트 시**:
- Redis: `petfood:rec:result:{pet_id}` 삭제
- Redis: `petfood:rec:meta:{pet_id}` 삭제 (현재 미사용)
- Redis: `petfood:rec:tags:{pet_id}` 삭제 (현재 미사용)
- PostgreSQL: 해당 `pet_id`의 모든 `RecommendationRun` 삭제 (cascade로 `RecommendationItem`도 자동 삭제)

### 4.2 수동 무효화

**특정 펫 캐시 삭제**:
- `DELETE /api/v1/products/recommendations/cache?pet_id={pet_id}`
- Redis + PostgreSQL 모두 삭제

**전체 캐시 삭제**:
- `DELETE /api/v1/products/recommendations/cache/all`
- Redis: `petfood:rec:*` 패턴의 모든 키 삭제
- PostgreSQL: 모든 `RecommendationRun` 삭제

---

## 5. 현재 상태 요약

| 캐시 타입 | 상태 | TTL | 실제 사용 여부 |
|---------|------|-----|--------------|
| **Redis: 추천 결과** | ✅ 활성화 | 7일 | ✅ 사용 중 |
| **Redis: 펫 프로필** | ⚠️ 구현됨 | 1시간 | ❌ 미사용 |
| **Redis: 상품 맞춤 점수** | ❌ 키만 정의 | 1시간 | ❌ 미구현 |
| **PostgreSQL: RecommendationRun** | ✅ 활성화 | 7일 (코드 기준) | ✅ 사용 중 |
| **PostgreSQL: RecommendationItem** | ✅ 활성화 | 7일 (코드 기준) | ✅ 사용 중 |

---

## 6. 실제 저장되는 데이터 크기

### 6.1 Redis 캐시 크기 예상

**단일 추천 결과**:
- 상품 10개 기준: 약 50-100KB (JSON)
- 펫당: 약 50-100KB
- 펫 10마리 기준: 약 500KB-1MB

### 6.2 PostgreSQL 캐시 크기

**RecommendationRun 1개**:
- 약 1-2KB (context JSONB 포함)

**RecommendationItem 1개**:
- 약 500 bytes - 1KB

**펫당 (상품 10개 기준)**:
- 약 10-20KB

---

## 7. 캐시 키 예시

### Redis 키
```
petfood:rec:result:12e923a5-e8f4-4835-afe3-2a06a8a9160c
petfood:rec:meta:12e923a5-e8f4-4835-afe3-2a06a8a9160c  (현재 미사용)
petfood:rec:tags:12e923a5-e8f4-4835-afe3-2a06a8a9160c   (현재 미사용)
petfood:pet:summary:12e923a5-e8f4-4835-afe3-2a06a8a9160c (현재 미사용)
```

### PostgreSQL 테이블
```
recommendation_runs
  - id: UUID
  - pet_id: UUID (인덱스)
  - created_at: TIMESTAMP (인덱스)

recommendation_items
  - run_id: UUID (PK, FK)
  - product_id: UUID (PK)
  - rank: INTEGER (인덱스)
```

---

## 8. 주의사항

1. **Redis는 메모리 기반**: 서버 재시작 시 데이터 손실 (TTL로 자동 만료)
2. **PostgreSQL은 영구 저장**: 명시적 삭제 전까지 유지
3. **일관성**: 펫 업데이트 시 Redis와 PostgreSQL 모두 삭제해야 함
4. **펫 프로필 캐시**: 구현되어 있지만 실제로 사용하지 않음 (향후 활용 가능)

---

## 9. 확인 방법

### Redis에서 확인
```bash
redis-cli

# 모든 추천 캐시 키 확인
KEYS petfood:rec:*

# 특정 펫의 캐시 확인
GET petfood:rec:result:12e923a5-e8f4-4835-afe3-2a06a8a9160c

# TTL 확인
TTL petfood:rec:result:12e923a5-e8f4-4835-afe3-2a06a8a9160c
```

### PostgreSQL에서 확인
```sql
-- 추천 실행 로그 확인
SELECT * FROM recommendation_runs 
WHERE pet_id = '12e923a5-e8f4-4835-afe3-2a06a8a9160c'
ORDER BY created_at DESC;

-- 추천 아이템 확인
SELECT * FROM recommendation_items 
WHERE run_id = 'a1b2c3d4-...'
ORDER BY rank;
```
