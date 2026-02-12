import { Award, ShoppingCart, Star, Gift } from 'lucide-react';

export function RewardSection() {
  return (
    <section className="py-24 px-6 lg:px-8" style={{ backgroundColor: '#EFF6FF' }}>
      <div className="max-w-7xl mx-auto">
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          <div className="space-y-8">
            <div className="space-y-6">
              <h2 className="text-4xl lg:text-5xl font-bold leading-tight" style={{ color: '#0F172A' }}>
                구매할수록<br />
                더 똑똑해집니다.
              </h2>
              
              <p className="text-lg leading-relaxed" style={{ color: '#475569' }}>
                구매와 이벤트 참여를 통해 포인트를 적립하고,<br />
                사료 또는 간식으로 교환할 수 있습니다.
              </p>
            </div>

            <div className="space-y-4">
              <div className="flex items-start gap-4">
                <div className="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#14B8A6' }}>
                  <ShoppingCart className="w-5 h-5 text-white" />
                </div>
                <div>
                  <div className="font-semibold mb-1" style={{ color: '#0F172A' }}>
                    구매 적립
                  </div>
                  <div className="text-sm" style={{ color: '#475569' }}>
                    사료 구매 시 최대 5% 포인트 적립
                  </div>
                </div>
              </div>

              <div className="flex items-start gap-4">
                <div className="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#14B8A6' }}>
                  <Star className="w-5 h-5 text-white" />
                </div>
                <div>
                  <div className="font-semibold mb-1" style={{ color: '#0F172A' }}>
                    이벤트 참여
                  </div>
                  <div className="text-sm" style={{ color: '#475569' }}>
                    리뷰 작성, 제품 평가로 추가 포인트 획득
                  </div>
                </div>
              </div>

              <div className="flex items-start gap-4">
                <div className="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#14B8A6' }}>
                  <Gift className="w-5 h-5 text-white" />
                </div>
                <div>
                  <div className="font-semibold mb-1" style={{ color: '#0F172A' }}>
                    포인트 교환
                  </div>
                  <div className="text-sm" style={{ color: '#475569' }}>
                    적립된 포인트로 사료 및 간식 구매 가능
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="relative">
            <div className="bg-white rounded-3xl shadow-2xl p-8">
              <div className="flex items-center justify-between mb-8">
                <div>
                  <div className="text-sm font-medium mb-2" style={{ color: '#475569' }}>
                    내 포인트
                  </div>
                  <div className="text-5xl font-bold" style={{ color: '#2563EB' }}>
                    12,850P
                  </div>
                </div>
                <div className="w-16 h-16 rounded-2xl flex items-center justify-center" style={{ backgroundColor: '#EFF6FF' }}>
                  <Award className="w-9 h-9" style={{ color: '#2563EB' }} />
                </div>
              </div>

              <div className="space-y-4">
                <div className="bg-gradient-to-r from-blue-50 to-teal-50 rounded-2xl p-5">
                  <div className="flex items-center justify-between mb-3">
                    <div className="text-sm font-semibold" style={{ color: '#0F172A' }}>
                      최근 적립 내역
                    </div>
                    <div className="text-xs font-medium" style={{ color: '#475569' }}>
                      오늘
                    </div>
                  </div>
                  <div className="space-y-2">
                    <div className="flex items-center justify-between text-sm">
                      <span style={{ color: '#475569' }}>사료 구매</span>
                      <span className="font-semibold" style={{ color: '#14B8A6' }}>+850P</span>
                    </div>
                    <div className="flex items-center justify-between text-sm">
                      <span style={{ color: '#475569' }}>리뷰 작성</span>
                      <span className="font-semibold" style={{ color: '#14B8A6' }}>+500P</span>
                    </div>
                  </div>
                </div>

                <div className="bg-gray-50 rounded-2xl p-5">
                  <div className="text-sm font-semibold mb-3" style={{ color: '#0F172A' }}>
                    교환 가능 상품
                  </div>
                  <div className="space-y-2">
                    <div className="flex items-center justify-between text-sm">
                      <span style={{ color: '#475569' }}>사료 2kg</span>
                      <span className="font-semibold" style={{ color: '#2563EB' }}>10,000P</span>
                    </div>
                    <div className="flex items-center justify-between text-sm">
                      <span style={{ color: '#475569' }}>프리미엄 간식</span>
                      <span className="font-semibold" style={{ color: '#2563EB' }}>5,000P</span>
                    </div>
                  </div>
                </div>
              </div>

              <button className="w-full mt-6 py-4 rounded-xl text-white font-semibold hover:opacity-90 transition-opacity" style={{ backgroundColor: '#14B8A6' }}>
                포인트 교환하기
              </button>
            </div>

            {/* Decorative Element */}
            <div className="absolute -z-10 -top-8 -right-8 w-64 h-64 rounded-full opacity-20" style={{ backgroundColor: '#14B8A6', filter: 'blur(60px)' }}></div>
          </div>
        </div>
      </div>
    </section>
  );
}
