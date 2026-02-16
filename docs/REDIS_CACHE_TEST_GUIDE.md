# Redis 캐시 테스트 가이드

## 1. 사전 준비

### 1.1 Redis 서버 실행 확인
```bash
# Redis 서버 상태 확인
redis-cli ping

# 응답이 "PONG"이면 정상
# 응답이 없으면 Redis 서버를 시작해야 합니다
```

### 1.2 Redis 서버 시작 (필요한 경우)
```bash
# macOS (Homebrew)
brew services start redis

# 또는 직접 실행
redis-server

# Docker 사용 시
docker run -d -p 6379:6379 redis:latest
```

## 2. 단위 테스트 실행

### 2.1 테스트 스크립트 실행
```bash
cd backend
python3 test_redis_cache.py
```

### 2.2 예상 출력
```
============================================================
Redis 캐시 구현 테스트
============================================================

=== 1. Redis 연결 테스트 ===
✅ Redis 연결 성공: True

=== 2. 캐시 키 생성 테스트 ===
✅ 추천 결과 키: petfood:rec:result:{pet_id}
✅ 메타데이터 키: petfood:rec:meta:{pet_id}
✅ 태그 키: petfood:rec:tags:{pet_id}
✅ 펫 프로필 키: petfood:pet:summary:{pet_id}

=== 3. 캐시 저장/조회 테스트 ===
📝 캐시 저장 시도: pet_id=...
✅ 캐시 저장: True
📖 캐시 조회 시도: pet_id=...
✅ 캐시 조회 성공: pet_id=..., is_cached=True

=== 4. 캐시 무효화 테스트 ===
📝 캐시 저장 완료: pet_id=...
✅ 무효화 전 조회: True
🗑️ 캐시 무효화 시도: pet_id=...
✅ 캐시 무효화: True
✅ 무효화 후 조회 (None이어야 함): True

=== 5. 펫 프로필 캐시 테스트 ===
✅ 펫 프로필 캐시 저장: True
✅ 펫 프로필 캐시 조회 성공: {...}
✅ 펫 프로필 캐시 무효화: True

=== 6. Redis Fallback 테스트 ===
⚠️ 이 테스트는 Redis가 정상 작동할 때는 항상 성공합니다
⚠️ 실제 fallback 테스트는 Redis를 중지한 상태에서 API 호출로 확인해야 합니다

============================================================
✅ 모든 테스트 완료!
============================================================
```

## 3. 통합 테스트 (API 호출)

### 3.1 백엔드 서버 시작
```bash
cd backend
uvicorn app.main:app --reload
```

### 3.2 추천 API 호출 테스트

#### 첫 번째 호출 (캐시 미스 → 새로 계산)
```bash
# 추천 요청
curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id={pet_id}" \
  -H "X-Device-UID: test-device-123"

# 예상 로그:
# [ProductService] ❌ Redis 캐시 미스: pet_id=...
# [ProductService] 🔄 새로운 추천 계산 시작
# [ProductService] ✅ 새 추천 계산 → Redis 캐시 저장 완료
```

#### 두 번째 호출 (캐시 히트)
```bash
# 동일한 요청 반복
curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id={pet_id}" \
  -H "X-Device-UID: test-device-123"

# 예상 로그:
# [ProductService] ✅ Redis 캐시 히트: pet_id=...
# (새로 계산하지 않고 즉시 반환)
```

### 3.3 펫 업데이트 후 캐시 무효화 테스트

```bash
# 1. 추천 요청 (캐시 생성)
curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id={pet_id}" \
  -H "X-Device-UID: test-device-123"

# 2. 펫 프로필 업데이트
curl -X PATCH "http://localhost:8000/api/v1/pets/{pet_id}" \
  -H "X-Device-UID: test-device-123" \
  -H "Content-Type: application/json" \
  -d '{"weight_kg": 12.5}'

# 예상 로그:
# [Pets API] ✅ 추천 캐시 무효화 완료: pet_id=...

# 3. 다시 추천 요청 (캐시가 무효화되어 새로 계산)
curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id={pet_id}" \
  -H "X-Device-UID: test-device-123"

# 예상 로그:
# [ProductService] ❌ Redis 캐시 미스: pet_id=...
# [ProductService] 🔄 새로운 추천 계산 시작
```

### 3.4 수동 캐시 삭제 테스트

```bash
# 캐시 삭제
curl -X DELETE "http://localhost:8000/api/v1/products/recommendations/cache?pet_id={pet_id}" \
  -H "X-Device-UID: test-device-123"

# 예상 응답:
# {
#   "success": true,
#   "pet_id": "...",
#   "deleted_runs": 1,
#   "redis_keys_deleted": 1
# }
```

## 4. Redis Fallback 테스트

### 4.1 Redis 서버 중지
```bash
# Redis 서버 중지
redis-cli shutdown

# 또는
brew services stop redis
```

### 4.2 API 호출 (Fallback 동작 확인)
```bash
# 추천 요청 (Redis 실패 시 PostgreSQL로 fallback)
curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id={pet_id}" \
  -H "X-Device-UID: test-device-123"

# 예상 로그:
# [RecommendationCache] Redis 조회 실패: ..., fallback to PostgreSQL
# [ProductService] ❌ Redis 캐시 미스: pet_id=...
# [ProductService] 💾 캐싱된 추천 사용: ... (PostgreSQL에서 조회)
```

### 4.3 Redis 서버 재시작
```bash
# Redis 서버 재시작
brew services start redis
# 또는
redis-server
```

## 5. Redis 데이터 확인

### 5.1 Redis CLI로 캐시 확인
```bash
# Redis CLI 접속
redis-cli

# 모든 추천 캐시 키 조회
KEYS petfood:rec:*

# 특정 펫의 캐시 확인
GET petfood:rec:result:{pet_id}

# TTL 확인 (남은 시간)
TTL petfood:rec:result:{pet_id}

# 캐시 삭제 (테스트용)
DEL petfood:rec:result:{pet_id}
```

### 5.2 캐시 통계 확인
```bash
redis-cli

# 전체 키 개수
DBSIZE

# 메모리 사용량
INFO memory

# 키 스캔 (패턴 매칭)
SCAN 0 MATCH petfood:rec:*
```

## 6. 성능 측정

### 6.1 캐시 히트 시 응답 시간
```bash
# 첫 번째 호출 (캐시 미스)
time curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id={pet_id}" \
  -H "X-Device-UID: test-device-123"

# 두 번째 호출 (캐시 히트)
time curl -X GET "http://localhost:8000/api/v1/products/recommendations?pet_id={pet_id}" \
  -H "X-Device-UID: test-device-123"

# 예상 결과:
# 첫 번째: 2-5초 (RAG 계산 포함)
# 두 번째: 0.1-0.5초 (Redis 캐시)
```

### 6.2 로그에서 캐시 히트율 확인
```bash
# 백엔드 로그에서 캐시 히트/미스 확인
tail -f backend/logs/app.log | grep "RecommendationCache"

# 또는
grep "Redis 캐시 히트" backend/logs/app.log | wc -l
grep "Redis 캐시 미스" backend/logs/app.log | wc -l
```

## 7. 문제 해결

### 7.1 Redis 연결 실패
```
에러: [RecommendationCache] Redis 조회 실패: ...
해결: Redis 서버가 실행 중인지 확인
```

### 7.2 캐시가 저장되지 않음
```
확인 사항:
1. Redis 서버 메모리 부족 여부
2. TTL 설정 확인
3. JSON 직렬화 오류 확인 (로그 확인)
```

### 7.3 캐시 무효화가 작동하지 않음
```
확인 사항:
1. 펫 업데이트 API가 정상 호출되었는지
2. Redis 키가 실제로 삭제되었는지 (redis-cli로 확인)
3. 로그에서 무효화 메시지 확인
```

## 8. 모니터링

### 8.1 주요 메트릭
- **캐시 히트율**: Redis Hit / Total Requests (목표: > 80%)
- **평균 응답 시간**: Redis Hit 시 < 5ms, Miss 시 < 100ms
- **Redis 메모리 사용량**: < 80% 권장

### 8.2 로그 모니터링
```bash
# 실시간 로그 모니터링
tail -f backend/logs/app.log | grep -E "RecommendationCache|Redis"
```

## 9. 다음 단계

테스트가 성공적으로 완료되면:
1. ✅ 프로덕션 배포 준비
2. ✅ 모니터링 대시보드 설정
3. ✅ 캐시 히트율 추적
4. ✅ 필요 시 펫 프로필 캐시, 상품 맞춤 점수 캐시 추가
