export function UsageGuide() {
  return (
    <div className="admin-card p-8 max-w-4xl">
      <h2 className="text-2xl font-bold text-gray-900 mb-6">사용 가이드</h2>

      <div className="space-y-8">
        <section>
          <h3 className="text-lg font-bold text-gray-900 mb-3">1. 이벤트 관리는 무엇을 하는 기능인가요?</h3>
          <p className="text-sm text-gray-600 mb-4">
            이벤트 관리는 사용자에게 노출할 프로모션/안내 메시지를
            <span className="font-semibold"> 언제, 누구에게, 어떤 우선순위로 보여줄지 </span>
            운영자가 직접 관리하는 화면입니다.
          </p>
          <ul className="list-disc list-inside text-sm text-gray-600 space-y-1">
            <li>캠페인을 생성해 노출 기간/우선순위/내용을 설정합니다.</li>
            <li>활성화/비활성화를 통해 즉시 노출 여부를 제어합니다.</li>
            <li>시뮬레이션으로 특정 사용자 상황에서 노출 결과를 사전 확인합니다.</li>
          </ul>
        </section>

        <section>
          <h3 className="text-lg font-bold text-gray-900 mb-3">2. 언제 사용하면 좋나요?</h3>
          <ul className="list-disc list-inside text-sm text-gray-600 space-y-1">
            <li>신규 이벤트/프로모션을 시작할 때</li>
            <li>기존 캠페인 노출 기간이나 우선순위를 조정할 때</li>
            <li>특정 조건에서 캠페인이 왜 노출/미노출되는지 확인할 때</li>
            <li>리워드 지급 결과나 노출 이력을 운영 점검할 때</li>
          </ul>
        </section>

        <section>
          <h3 className="text-lg font-bold text-gray-900 mb-3">3. 탭별로 하는 일</h3>
          <div className="space-y-3">
            <div className="p-4 bg-gray-50 border border-gray-200 rounded-xl">
              <h4 className="text-sm font-semibold text-gray-900 mb-1">캠페인 목록</h4>
              <p className="text-sm text-gray-700">
                캠페인 생성, 조회, 활성/비활성, 우선순위 관리
              </p>
            </div>
            <div className="p-4 bg-gray-50 border border-gray-200 rounded-xl">
              <h4 className="text-sm font-semibold text-gray-900 mb-1">시뮬레이션</h4>
              <p className="text-sm text-gray-700">
                특정 사용자/조건에서 어떤 캠페인이 적용되는지 사전 검증
              </p>
            </div>
            <div className="p-4 bg-gray-50 border border-gray-200 rounded-xl">
              <h4 className="text-sm font-semibold text-gray-900 mb-1">노출 이력</h4>
              <p className="text-sm text-gray-700">
                실제 노출된 캠페인 기록 확인
              </p>
            </div>
            <div className="p-4 bg-gray-50 border border-gray-200 rounded-xl">
              <h4 className="text-sm font-semibold text-gray-900 mb-1">리워드 이력</h4>
              <p className="text-sm text-gray-700">
                지급 상태(PENDING/COMPLETED 등) 점검 및 운영 이슈 추적
              </p>
            </div>
          </div>
        </section>

        <section>
          <h3 className="text-lg font-bold text-gray-900 mb-3">4. 운영 체크리스트</h3>
          <p className="text-sm text-gray-600 mb-4">
            캠페인을 운영할 때 아래 항목을 먼저 확인하면 오류를 줄일 수 있습니다.
          </p>
          <ul className="list-disc list-inside text-sm text-gray-600 space-y-1">
            <li>활성화 상태(ON/OFF) 확인</li>
            <li>노출 기간(시작/종료일) 확인</li>
            <li>우선순위(Priority) 충돌 여부 확인</li>
            <li>캠페인 제목/설명/링크 등 콘텐츠 오탈자 확인</li>
            <li>시뮬레이션으로 실제 적용 결과 최종 확인</li>
          </ul>
        </section>

        <section>
          <h3 className="text-lg font-bold text-gray-900 mb-3">5. 자주 묻는 운영 질문</h3>
          <div className="space-y-3">
            <div className="p-4 bg-yellow-50 border border-yellow-200 rounded-xl">
              <h4 className="text-sm font-semibold text-yellow-900 mb-1">
                캠페인이 노출되지 않아요
              </h4>
              <p className="text-sm text-yellow-700">
                활성화 상태, 노출 기간, 우선순위를 먼저 확인하고
                시뮬레이션으로 해당 사용자 조건을 재검증하세요.
              </p>
            </div>

            <div className="p-4 bg-blue-50 border border-blue-200 rounded-xl">
              <h4 className="text-sm font-semibold text-blue-900 mb-1">
                리워드가 지급되지 않아요
              </h4>
              <p className="text-sm text-blue-700">
                리워드 이력에서 상태를 확인하고, 장시간 PENDING이면
                운영 담당자에게 처리 상태를 확인하세요.
              </p>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
}