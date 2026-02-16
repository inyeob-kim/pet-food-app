# Redis 캐시 API 테스트 가이드

## 빠른 시작

### 방법 1: 자동화 스크립트 사용 (권장)

```bash
cd backend
./test_api_redis_cache.sh
```

스크립트가 자동으로:
1. 펫 목록 조회
2. 첫 번째 추천 요청 (캐시 미스)
3. 두 번째 추천 요청 (캐시 히트)
4. Redis에서 캐시 확인
5. 펫 업데이트 후 캐시 무효화 테스트 (선택)

---

## 방법 2: 수동 테스트

### 1단계: 펫 ID 조회

```bash
curl -X GET "http://localhost:8000/api/v1/pets" \
  -H "X-Device-UID: test-device-123"
```

**응답 예시:**
```json
[
  {
    "id": "12e923a5-e8f4-4835-afe3-2a06a8a9160c",
    "name": "멍멍이",
    ...
  }
]
```

**PET_ID 변수에 저장:**
```bash
PET_ID="12e923a5-e8f4-4835-afe3-2a06a8a9160c"
```

---

### 2단계: 첫 번째 추천 요청 (캐시 미스)

```bash
curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id=$PET_ID" \
  -H "X-Device-UID: test-device-123" \
  -w "\n\n응답 시간: %{time_total}초\n"
```

**예상 결과:**
- 응답 시간: **2-5초** (RAG 계산 포함)
- 백엔드 로그: `❌ Redis 캐시 미스` → `🔄 새로운 추천 계산 시작` → `✅ 새 추천 계산 → Redis 캐시 저장 완료`

---

### 3단계: 두 번째 추천 요청 (캐시 히트)

```bash
# 동일한 요청 반복
curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id=$PET_ID" \
  -H "X-Device-UID: test-device-123" \
  -w "\n\n응답 시간: %{time_total}초\n"
```

**예상 결과:**
- 응답 시간: **0.1-0.5초** (Redis 캐시)
- 백엔드 로그: `✅ Redis 캐시 히트`
- 성능 개선: **90-95% 감소**

---

### 4단계: Redis에서 직접 확인

```bash
# Redis CLI 접속
redis-cli

# 캐시 키 확인
KEYS petfood:rec:*

# 특정 펫의 캐시 확인
GET petfood:rec:result:12e923a5-e8f4-4835-afe3-2a06a8a9160c

# TTL 확인 (남은 시간, 초 단위)
TTL petfood:rec:result:12e923a5-e8f4-4835-afe3-2a06a8a9160c
# 예상: 604800 (7일 = 604800초)
```

---

### 5단계: 펫 업데이트 후 캐시 무효화 테스트

```bash
# 펫 프로필 업데이트 (체중 변경)
curl -X PATCH "http://localhost:8000/api/v1/pets/$PET_ID" \
  -H "X-Device-UID: test-device-123" \
  -H "Content-Type: application/json" \
  -d '{"weight_kg": 12.5}'
```

**예상 로그:**
```
[Pets API] ✅ 추천 캐시 무효화 완료: pet_id=...
```

**Redis에서 확인:**
```bash
redis-cli
GET petfood:rec:result:12e923a5-e8f4-4835-afe3-2a06a8a9160c
# (nil) - 캐시가 삭제되었음
```

**다시 추천 요청:**
```bash
curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id=$PET_ID" \
  -H "X-Device-UID: test-device-123"
```

**예상 로그:**
```
[ProductService] ❌ Redis 캐시 미스: pet_id=...
[ProductService] 🔄 새로운 추천 계산 시작
[ProductService] ✅ 새 추천 계산 → Redis 캐시 저장 완료
```

---

### 6단계: 수동 캐시 삭제 테스트

```bash
curl -X DELETE "http://localhost:8000/api/v1/products/recommendations/cache?pet_id=$PET_ID" \
  -H "X-Device-UID: test-device-123"
```

**예상 응답:**
```json
{
  "success": true,
  "pet_id": "12e923a5-e8f4-4835-afe3-2a06a8a9160c",
  "deleted_runs": 1,
  "redis_keys_deleted": 1
}
```

---

## 성능 비교

| 시나리오 | 예상 응답 시간 | 로그 메시지 |
|---------|--------------|------------|
| 첫 호출 (캐시 미스) | 2-5초 | `❌ Redis 캐시 미스` → `새 추천 계산` |
| 두 번째 호출 (캐시 히트) | 0.1-0.5초 | `✅ Redis 캐시 히트` |
| **성능 개선** | **90-95% 감소** | - |

---

## 백엔드 로그 확인

백엔드 서버 콘솔에서 다음 메시지들을 확인하세요:

### 캐시 히트
```
[ProductService] ✅ Redis 캐시 히트: pet_id=...
```

### 캐시 미스
```
[ProductService] ❌ Redis 캐시 미스: pet_id=..., PostgreSQL 확인
```

### 캐시 저장
```
[RecommendationCache] ✅ 캐시 저장: pet_id=..., TTL=604800초
[ProductService] ✅ 새 추천 계산 → Redis 캐시 저장 완료
```

### 캐시 무효화
```
[RecommendationCache] ✅ 캐시 무효화: pet_id=..., deleted=3개 키
[Pets API] ✅ 추천 캐시 무효화 완료: pet_id=...
```

### Redis 에러 (Fallback)
```
[RecommendationCache] Redis 조회 실패: ..., fallback to PostgreSQL
[ProductService] ❌ Redis 캐시 미스: pet_id=..., PostgreSQL 확인
```

---

## 문제 해결

### Redis 연결 실패
```
에러: [RecommendationCache] Redis 조회 실패: ...
해결: Redis 서버가 실행 중인지 확인
```
```bash
redis-cli ping
# "PONG" 응답이 나와야 함
```

### 캐시가 저장되지 않음
1. Redis 서버 메모리 확인
2. 백엔드 로그에서 에러 메시지 확인
3. TTL 설정 확인 (7일 = 604800초)

### 캐시 무효화가 작동하지 않음
1. 펫 업데이트 API가 정상 호출되었는지 확인
2. Redis에서 키가 실제로 삭제되었는지 확인
3. 백엔드 로그에서 무효화 메시지 확인

---

## 추가 테스트 시나리오

### Force Refresh 테스트
```bash
# force_refresh=true로 강제 재계산
curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id=$PET_ID&force_refresh=true" \
  -H "X-Device-UID: test-device-123"
```

**예상 로그:**
```
[ProductService] 🔄 force_refresh=true: 캐시 무시하고 새로 계산
[ProductService] 🔄 새로운 추천 계산 시작
```

### Redis Fallback 테스트
```bash
# 1. Redis 서버 중지
redis-cli shutdown

# 2. 추천 요청 (PostgreSQL로 fallback)
curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id=$PET_ID" \
  -H "X-Device-UID: test-device-123"

# 3. Redis 서버 재시작
redis-server
```

**예상 로그:**
```
[RecommendationCache] Redis 조회 실패: ..., fallback to PostgreSQL
[ProductService] 💾 캐싱된 추천 사용: ... (PostgreSQL에서 조회)
```

---

## 완료 체크리스트

- [ ] 첫 번째 요청이 2-5초 소요 (캐시 미스)
- [ ] 두 번째 요청이 0.1-0.5초 소요 (캐시 히트)
- [ ] 백엔드 로그에 "✅ Redis 캐시 히트" 메시지 확인
- [ ] Redis CLI에서 캐시 키 확인
- [ ] 펫 업데이트 후 캐시 무효화 확인
- [ ] 수동 캐시 삭제 API 동작 확인

모든 항목이 체크되면 Redis 캐시 시스템이 정상 작동하는 것입니다! 🎉
