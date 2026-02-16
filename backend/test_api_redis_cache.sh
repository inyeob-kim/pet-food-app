#!/bin/bash

# Redis 캐시 API 테스트 스크립트
# 사용법: ./test_api_redis_cache.sh

BASE_URL="http://localhost:8000/api/v1"
DEVICE_UID="test-device-123"

echo "============================================================"
echo "Redis 캐시 API 테스트"
echo "============================================================"
echo ""

# 색상 정의
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. 펫 목록 조회
echo -e "${YELLOW}=== 1단계: 펫 목록 조회 ===${NC}"
echo "요청: GET $BASE_URL/pets"
echo ""

PET_RESPONSE=$(curl -s -X GET "$BASE_URL/pets" \
  -H "X-Device-UID: $DEVICE_UID")

echo "응답:"
echo "$PET_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$PET_RESPONSE"
echo ""

# pet_id 추출 (첫 번째 펫의 id 사용)
PET_ID=$(echo "$PET_RESPONSE" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data[0]['id'] if data and len(data) > 0 else '')" 2>/dev/null)

if [ -z "$PET_ID" ]; then
    echo -e "${YELLOW}⚠️ 펫이 없습니다. 테스트용 펫을 생성합니다...${NC}"
    echo ""
    
    # 테스트용 펫 생성
    CREATE_RESPONSE=$(curl -s -X POST "$BASE_URL/pets" \
      -H "X-Device-UID: $DEVICE_UID" \
      -H "Content-Type: application/json" \
      -d '{
        "name": "테스트펫",
        "species": "DOG",
        "breed_code": "MIX",
        "sex": "MALE",
        "approx_age_months": 24,
        "weight_kg": 10.0,
        "is_neutered": false,
        "is_primary": true
      }')
    
    echo "생성 응답:"
    echo "$CREATE_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$CREATE_RESPONSE"
    echo ""
    
    # 생성된 펫의 ID 추출
    PET_ID=$(echo "$CREATE_RESPONSE" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('id', ''))" 2>/dev/null)
    
    if [ -z "$PET_ID" ]; then
        echo -e "${RED}❌ 펫 생성 실패. 수동으로 펫을 생성해주세요.${NC}"
        echo ""
        echo "수동 생성 명령어:"
        echo "curl -X POST \"$BASE_URL/pets\" \\"
        echo "  -H \"X-Device-UID: $DEVICE_UID\" \\"
        echo "  -H \"Content-Type: application/json\" \\"
        echo "  -d '{\"name\": \"테스트펫\", \"species\": \"DOG\", \"breed_code\": \"MIX\", \"sex\": \"MALE\", \"approx_age_months\": 24, \"weight_kg\": 10.0, \"is_neutered\": false, \"is_primary\": true}'"
        exit 1
    fi
    
    echo -e "${GREEN}✅ 테스트용 펫 생성 완료${NC}"
    echo ""
fi

echo -e "${GREEN}✅ 펫 ID: $PET_ID${NC}"
echo ""
echo "============================================================"
echo ""

# 2. 첫 번째 추천 요청 (캐시 미스)
echo -e "${YELLOW}=== 2단계: 첫 번째 추천 요청 (캐시 미스 예상) ===${NC}"
echo "요청: GET $BASE_URL/products/recommendations?pet_id=$PET_ID"
echo ""
echo "⏳ 계산 중... (2-5초 소요 예상)"
echo ""

START_TIME=$(date +%s.%N)
RECOMMENDATION_RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}\nTIME_TOTAL:%{time_total}" \
  -X GET "$BASE_URL/products/recommendations?pet_id=$PET_ID" \
  -H "X-Device-UID: $DEVICE_UID")
END_TIME=$(date +%s.%N)

# 응답과 메타데이터 분리
HTTP_CODE=$(echo "$RECOMMENDATION_RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
TIME_TOTAL=$(echo "$RECOMMENDATION_RESPONSE" | grep "TIME_TOTAL:" | cut -d: -f2)
RESPONSE_BODY=$(echo "$RECOMMENDATION_RESPONSE" | sed '/HTTP_CODE:/d' | sed '/TIME_TOTAL:/d')

echo "응답 시간: ${TIME_TOTAL}초"
echo "HTTP 상태 코드: $HTTP_CODE"
echo ""

if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ 첫 번째 요청 성공${NC}"
    echo ""
    echo "응답 (일부):"
    echo "$RESPONSE_BODY" | python3 -c "import sys, json; data=json.load(sys.stdin); print(f\"pet_id: {data.get('pet_id', 'N/A')}\"); print(f\"items: {len(data.get('items', []))}개\"); print(f\"is_cached: {data.get('is_cached', False)}\")" 2>/dev/null || echo "응답 파싱 실패"
else
    echo -e "${RED}❌ 첫 번째 요청 실패 (HTTP $HTTP_CODE)${NC}"
    echo "응답:"
    echo "$RESPONSE_BODY"
fi

echo ""
echo "💡 백엔드 로그에서 다음 메시지를 확인하세요:"
echo "   - '❌ Redis 캐시 미스' 또는 '✅ Redis 캐시 히트'"
echo ""
echo "============================================================"
echo ""

# 3. 두 번째 추천 요청 (캐시 히트 예상)
echo -e "${YELLOW}=== 3단계: 두 번째 추천 요청 (캐시 히트 예상) ===${NC}"
echo "요청: GET $BASE_URL/products/recommendations?pet_id=$PET_ID"
echo ""
echo "⏳ 조회 중... (0.1-0.5초 소요 예상)"
echo ""

START_TIME=$(date +%s.%N)
RECOMMENDATION_RESPONSE2=$(curl -s -w "\nHTTP_CODE:%{http_code}\nTIME_TOTAL:%{time_total}" \
  -X GET "$BASE_URL/products/recommendations?pet_id=$PET_ID" \
  -H "X-Device-UID: $DEVICE_UID")
END_TIME=$(date +%s.%N)

HTTP_CODE2=$(echo "$RECOMMENDATION_RESPONSE2" | grep "HTTP_CODE:" | cut -d: -f2)
TIME_TOTAL2=$(echo "$RECOMMENDATION_RESPONSE2" | grep "TIME_TOTAL:" | cut -d: -f2)
RESPONSE_BODY2=$(echo "$RECOMMENDATION_RESPONSE2" | sed '/HTTP_CODE:/d' | sed '/TIME_TOTAL:/d')

echo "응답 시간: ${TIME_TOTAL2}초"
echo "HTTP 상태 코드: $HTTP_CODE2"
echo ""

if [ "$HTTP_CODE2" = "200" ]; then
    echo -e "${GREEN}✅ 두 번째 요청 성공${NC}"
    echo ""
    echo "응답 (일부):"
    echo "$RESPONSE_BODY2" | python3 -c "import sys, json; data=json.load(sys.stdin); print(f\"pet_id: {data.get('pet_id', 'N/A')}\"); print(f\"items: {len(data.get('items', []))}개\"); print(f\"is_cached: {data.get('is_cached', False)}\")" 2>/dev/null || echo "응답 파싱 실패"
    
    # 성능 비교
    echo ""
    if (( $(echo "$TIME_TOTAL2 < $TIME_TOTAL" | bc -l) )); then
        IMPROVEMENT=$(python3 -c "print(f'{((1 - $TIME_TOTAL2 / $TIME_TOTAL) * 100):.1f}%')" 2>/dev/null || echo "계산 불가")
        echo -e "${GREEN}🚀 성능 개선: $IMPROVEMENT 감소${NC}"
    fi
else
    echo -e "${RED}❌ 두 번째 요청 실패 (HTTP $HTTP_CODE2)${NC}"
fi

echo ""
echo "💡 백엔드 로그에서 다음 메시지를 확인하세요:"
echo "   - '✅ Redis 캐시 히트' (빠른 응답)"
echo ""
echo "============================================================"
echo ""

# 4. Redis에서 직접 확인
echo -e "${YELLOW}=== 4단계: Redis에서 캐시 확인 ===${NC}"
echo "Redis CLI로 확인:"
echo ""
echo "redis-cli"
echo "KEYS petfood:rec:*"
echo "GET petfood:rec:result:$PET_ID"
echo "TTL petfood:rec:result:$PET_ID"
echo ""

# Redis CLI가 있으면 자동으로 확인 시도
if command -v redis-cli &> /dev/null; then
    echo "자동 확인 시도..."
    REDIS_KEYS=$(redis-cli KEYS "petfood:rec:result:$PET_ID" 2>/dev/null)
    if [ -n "$REDIS_KEYS" ]; then
        echo -e "${GREEN}✅ Redis에 캐시가 저장되어 있습니다${NC}"
        TTL=$(redis-cli TTL "petfood:rec:result:$PET_ID" 2>/dev/null)
        echo "TTL (남은 시간): ${TTL}초"
    else
        echo -e "${YELLOW}⚠️ Redis에 캐시가 없습니다 (정상일 수 있음)${NC}"
    fi
else
    echo "redis-cli를 찾을 수 없습니다. 수동으로 확인해주세요."
fi

echo ""
echo "============================================================"
echo ""

# 5. 펫 업데이트 후 캐시 무효화 테스트 (선택사항)
echo -e "${YELLOW}=== 5단계: 펫 업데이트 후 캐시 무효화 테스트 (선택사항) ===${NC}"
read -p "펫 프로필을 업데이트하여 캐시 무효화를 테스트하시겠습니까? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "펫 체중 업데이트 중..."
    UPDATE_RESPONSE=$(curl -s -X PATCH "$BASE_URL/pets/$PET_ID" \
      -H "X-Device-UID: $DEVICE_UID" \
      -H "Content-Type: application/json" \
      -d '{"weight_kg": 12.5}')
    
    echo "응답:"
    echo "$UPDATE_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$UPDATE_RESPONSE"
    echo ""
    
    echo "💡 백엔드 로그에서 다음 메시지를 확인하세요:"
    echo "   - '✅ 추천 캐시 무효화 완료'"
    echo ""
    
    # Redis에서 확인
    if command -v redis-cli &> /dev/null; then
        REDIS_KEYS_AFTER=$(redis-cli KEYS "petfood:rec:result:$PET_ID" 2>/dev/null)
        if [ -z "$REDIS_KEYS_AFTER" ]; then
            echo -e "${GREEN}✅ 캐시가 무효화되었습니다 (Redis에서 삭제됨)${NC}"
        else
            echo -e "${YELLOW}⚠️ 캐시가 아직 남아있습니다${NC}"
        fi
    fi
fi

echo ""
echo "============================================================"
echo -e "${GREEN}✅ API 테스트 완료!${NC}"
echo "============================================================"
