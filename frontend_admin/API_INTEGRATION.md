# API 연동 점검 보고서

## 📋 개요

Figma로 만든 관리자 대시보드 코드를 백엔드 API와 연동하기 위해 전체 소스 코드를 점검하고 수정했습니다.

## ✅ 완료된 작업

### 1. API 설정 및 인프라

#### 생성된 파일
- `src/config/api.ts`: API 기본 설정, 헤더, 에러 처리
- `src/services/productService.ts`: 상품 관리 API 서비스
- `src/services/campaignService.ts`: 캠페인 관리 API 서비스

#### 주요 기능
- ✅ API Base URL 환경 변수 지원 (`VITE_API_BASE_URL`)
- ✅ 통합 에러 처리 (`ApiError` 클래스)
- ✅ 자동 헤더 설정
- ✅ 타입 안전성 보장

### 2. Vite 설정 수정

#### `vite.config.ts` 변경사항
```typescript
server: {
  port: 3000,
  open: true,
  proxy: {
    '/api': {
      target: 'http://localhost:8000',
      changeOrigin: true,
      secure: false,
    },
    '/admin': {
      target: 'http://localhost:8000',
      changeOrigin: true,
      secure: false,
    },
  },
}
```

**효과**: 개발 환경에서 CORS 문제 없이 API 호출 가능

### 3. 컴포넌트 API 연동

#### 사료 성분 관리 (IngredientsTab)
- ✅ `IngredientsTab.tsx`: Mock 데이터 → API 호출로 변경
- ✅ `ProductList.tsx`: 새로고침 기능 API 연동
- ✅ 상품 목록 조회 (`GET /api/v1/admin/products`)
- ✅ 상품 상세 조회 (`GET /api/v1/admin/products/{id}`)
- ✅ 상품 생성 (`POST /api/v1/admin/products`)
- ✅ 상품 수정 (`PUT /api/v1/admin/products/{id}`)
- ✅ 상품 비활성화 (`POST /api/v1/admin/products/{id}/archive`)
- ✅ 로딩 상태 및 에러 처리 추가

#### 이벤트 관리 (EventsTab)
- ✅ `CampaignList.tsx`: Mock 데이터 → API 호출로 변경
- ✅ `RewardsList.tsx`: Mock 데이터 → API 호출로 변경
- ✅ `ImpressionsList.tsx`: Mock 데이터 → API 호출로 변경
- ✅ `SimulationPanel.tsx`: Mock 데이터 → API 호출로 변경

**연동된 API 엔드포인트:**
- 캠페인 목록 조회 (`GET /admin/campaigns`)
- 캠페인 상세 조회 (`GET /admin/campaigns/{id}`)
- 캠페인 생성 (`POST /admin/campaigns`)
- 캠페인 수정 (`PUT /admin/campaigns/{id}`)
- 캠페인 활성화/비활성화 (`POST /admin/campaigns/{id}/toggle`)
- 리워드 조회 (`GET /admin/rewards`)
- 노출 조회 (`GET /admin/impressions`)
- 시뮬레이션 실행 (`POST /admin/campaigns/simulate`)

### 4. 에러 처리 및 사용자 경험 개선

- ✅ 모든 API 호출에 try-catch 추가
- ✅ `ApiError` 클래스를 통한 통합 에러 처리
- ✅ Toast 알림으로 사용자 피드백 제공
- ✅ 로딩 상태 표시
- ✅ 빈 상태 처리 (데이터 없을 때)
- ✅ 에러 발생 시 재시도 버튼 제공

## 📝 API 엔드포인트 매핑

### 상품 관리 API

| 기능 | HTTP Method | 엔드포인트 | 서비스 메서드 |
|------|------------|-----------|--------------|
| 상품 목록 조회 | GET | `/api/v1/admin/products` | `productService.getProducts()` |
| 상품 상세 조회 | GET | `/api/v1/admin/products/{id}` | `productService.getProduct()` |
| 상품 생성 | POST | `/api/v1/admin/products` | `productService.createProduct()` |
| 상품 수정 | PUT | `/api/v1/admin/products/{id}` | `productService.updateProduct()` |
| 상품 비활성화 | POST | `/api/v1/admin/products/{id}/archive` | `productService.archiveProduct()` |
| 상품 활성화 | POST | `/api/v1/admin/products/{id}/unarchive` | `productService.unarchiveProduct()` |
| 성분 정보 조회 | GET | `/api/v1/admin/products/{id}/ingredient` | `productService.getIngredient()` |
| 성분 정보 수정 | PUT | `/api/v1/admin/products/{id}/ingredient` | `productService.updateIngredient()` |
| 성분 분석 및 저장 | POST | `/api/v1/admin/products/{id}/ingredient/analyze-and-save` | `productService.analyzeAndSaveIngredient()` |
| 영양 정보 조회 | GET | `/api/v1/admin/products/{id}/nutrition` | `productService.getNutrition()` |
| 영양 정보 수정 | PUT | `/api/v1/admin/products/{id}/nutrition` | `productService.updateNutrition()` |
| 알레르겐 코드 목록 | GET | `/api/v1/admin/allergen-codes` | `productService.getAllergenCodes()` |
| 상품 알레르겐 조회 | GET | `/api/v1/admin/products/{id}/allergens` | `productService.getProductAllergens()` |
| 알레르겐 추가 | POST | `/api/v1/admin/products/{id}/allergens` | `productService.addAllergen()` |
| 알레르겐 삭제 | DELETE | `/api/v1/admin/products/{id}/allergens/{code}` | `productService.deleteAllergen()` |
| 클레임 코드 목록 | GET | `/api/v1/admin/claim-codes` | `productService.getClaimCodes()` |
| 상품 클레임 조회 | GET | `/api/v1/admin/products/{id}/claims` | `productService.getProductClaims()` |
| 클레임 추가 | POST | `/api/v1/admin/products/{id}/claims` | `productService.addClaim()` |
| 클레임 삭제 | DELETE | `/api/v1/admin/products/{id}/claims/{code}` | `productService.deleteClaim()` |
| 판매처 목록 조회 | GET | `/api/v1/admin/products/{id}/offers` | `productService.getOffers()` |
| 판매처 추가 | POST | `/api/v1/admin/products/{id}/offers` | `productService.addOffer()` |
| 판매처 수정 | PUT | `/api/v1/admin/offers/{id}` | `productService.updateOffer()` |
| 판매처 삭제 | DELETE | `/api/v1/admin/offers/{id}` | `productService.deleteOffer()` |
| 이미지 목록 조회 | GET | `/api/v1/admin/products/{id}/images` | `productService.getImages()` |

### 이벤트 관리 API

| 기능 | HTTP Method | 엔드포인트 | 서비스 메서드 |
|------|------------|-----------|--------------|
| 캠페인 목록 조회 | GET | `/admin/campaigns` | `campaignService.getCampaigns()` |
| 캠페인 상세 조회 | GET | `/admin/campaigns/{id}` | `campaignService.getCampaign()` |
| 캠페인 생성 | POST | `/admin/campaigns` | `campaignService.createCampaign()` |
| 캠페인 수정 | PUT | `/admin/campaigns/{id}` | `campaignService.updateCampaign()` |
| 캠페인 활성화/비활성화 | POST | `/admin/campaigns/{id}/toggle` | `campaignService.toggleCampaign()` |
| 리워드 조회 | GET | `/admin/rewards` | `campaignService.getRewards()` |
| 노출 조회 | GET | `/admin/impressions` | `campaignService.getImpressions()` |
| 시뮬레이션 실행 | POST | `/admin/campaigns/simulate` | `campaignService.simulate()` |

## 🔧 수정된 파일 목록

### 새로 생성된 파일
1. `src/config/api.ts` - API 설정 및 유틸리티
2. `src/services/productService.ts` - 상품 관리 서비스
3. `src/services/campaignService.ts` - 캠페인 관리 서비스

### 수정된 파일
1. `vite.config.ts` - Proxy 설정 추가
2. `src/pages/IngredientsTab.tsx` - API 연동
3. `src/components/ingredients/ProductList.tsx` - API 연동
4. `src/components/events/CampaignList.tsx` - API 연동
5. `src/components/events/RewardsList.tsx` - API 연동
6. `src/components/events/ImpressionsList.tsx` - API 연동
7. `src/components/events/SimulationPanel.tsx` - API 연동

## ⚠️ 보완이 필요한 부분

### 1. ProductDetail 컴포넌트
**현재 상태**: Mock 데이터 사용 중

**필요한 작업**:
- [ ] 성분 정보 로드 API 연동
- [ ] 영양 정보 로드 API 연동
- [ ] 알레르겐 목록 로드 API 연동
- [ ] 클레임 목록 로드 API 연동
- [ ] 판매처 목록 로드 API 연동
- [ ] 이미지 목록 로드 API 연동
- [ ] 각 정보 수정 API 연동

**예상 작업량**: 중간 (약 2-3시간)

### 2. CampaignDetailSheet 컴포넌트
**현재 상태**: Mock 데이터 사용 중

**필요한 작업**:
- [ ] 캠페인 상세 정보 로드 API 연동
- [ ] 캠페인 수정 API 연동
- [ ] 캠페인 삭제 기능 추가 (API 엔드포인트 확인 필요)

**예상 작업량**: 낮음 (약 1시간)

### 3. CreateCampaignDialog 컴포넌트
**현재 상태**: Mock 데이터 사용 중

**필요한 작업**:
- [ ] 캠페인 생성 폼 검증 강화
- [ ] Rules Builder API 연동
- [ ] Actions 설정 API 연동
- [ ] 미리보기 기능 개선

**예상 작업량**: 중간 (약 2시간)

### 4. 환경 변수 설정
**현재 상태**: `.env.example` 파일 생성 필요

**필요한 작업**:
- [ ] `.env.example` 파일 생성 (globalignore로 차단됨)
- [ ] `.env.local` 파일 생성 가이드 제공
- [ ] 프로덕션 환경 변수 설정 가이드

**예상 작업량**: 낮음 (약 30분)

### 5. 인증/인가
**현재 상태**: 미구현

**필요한 작업**:
- [ ] 인증 토큰 관리
- [ ] API 요청에 토큰 추가
- [ ] 토큰 만료 시 자동 갱신
- [ ] 로그인 페이지 연동

**예상 작업량**: 높음 (약 4-5시간)

### 6. 타입 정의 개선
**현재 상태**: 기본 타입만 정의됨

**필요한 작업**:
- [ ] API 응답 타입 정확히 매핑
- [ ] Mock 데이터 타입과 API 응답 타입 통합
- [ ] 타입 안전성 강화

**예상 작업량**: 중간 (약 2시간)

## 🚀 사용 방법

### 1. 환경 변수 설정

프로젝트 루트에 `.env.local` 파일 생성:

```env
VITE_API_BASE_URL=http://localhost:8000
```

### 2. 개발 서버 실행

```bash
npm install
npm run dev
```

### 3. 백엔드 서버 실행

백엔드 서버가 `http://localhost:8000`에서 실행 중이어야 합니다.

## 📊 테스트 체크리스트

### 상품 관리
- [ ] 상품 목록 조회
- [ ] 상품 상세 조회
- [ ] 상품 생성
- [ ] 상품 수정
- [ ] 상품 비활성화
- [ ] 필터링 및 검색
- [ ] 페이지네이션

### 이벤트 관리
- [ ] 캠페인 목록 조회
- [ ] 캠페인 생성
- [ ] 캠페인 수정
- [ ] 캠페인 활성화/비활성화
- [ ] 리워드 조회
- [ ] 노출 조회
- [ ] 시뮬레이션 실행

## 🔍 알려진 이슈

1. **타입 불일치**: Mock 데이터 타입과 실제 API 응답 타입이 다를 수 있음
   - 해결: API 응답 확인 후 타입 수정 필요

2. **에러 메시지**: 일부 API 에러 메시지가 사용자 친화적이지 않을 수 있음
   - 해결: 에러 메시지 매핑 추가

3. **로딩 상태**: 일부 컴포넌트에서 로딩 상태가 표시되지 않을 수 있음
   - 해결: 로딩 상태 UI 추가

## 📝 다음 단계

1. ProductDetail 컴포넌트 API 연동 완료
2. CampaignDetailSheet 및 CreateCampaignDialog API 연동 완료
3. 인증/인가 시스템 구현
4. 타입 정의 개선
5. E2E 테스트 작성
6. 에러 처리 강화
7. 성능 최적화 (캐싱, 무한 스크롤 등)

## 📞 문의

API 연동 관련 문의사항이 있으시면 이슈를 등록해주세요.
