import { AlertTriangle, TrendingDown } from 'lucide-react';
import { AppMockup } from './AppMockup';

interface HeroSectionProps {
  onOpenModal?: () => void;
}

export function HeroSection({ onOpenModal }: HeroSectionProps) {
  return (
    <section className="pt-32 pb-24 px-6 lg:px-8" style={{ backgroundColor: '#EFF6FF' }}>
      <div className="max-w-7xl mx-auto">
        {/* 상단 숫자 카드 */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-16">
          <div className="bg-white rounded-2xl p-6 border-2 shadow-sm" style={{ borderColor: '#EF4444' }}>
            <div className="flex items-start gap-3">
              <div className="w-10 h-10 rounded-xl flex items-center justify-center" style={{ backgroundColor: '#FEE2E2' }}>
                <AlertTriangle className="w-5 h-5" style={{ color: '#EF4444' }} />
              </div>
              <div>
                <div className="text-2xl font-bold mb-1" style={{ color: '#EF4444' }}>
                  위험 성분 2개 감지
                </div>
                <div className="text-sm" style={{ color: '#475569' }}>
                  즉시 확인이 필요합니다
                </div>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-2xl p-6 border-2 shadow-sm" style={{ borderColor: '#F59E0B' }}>
            <div className="flex items-start gap-3">
              <div className="w-10 h-10 rounded-xl flex items-center justify-center" style={{ backgroundColor: '#FEF3C7' }}>
                <AlertTriangle className="w-5 h-5" style={{ color: '#F59E0B' }} />
              </div>
              <div>
                <div className="text-2xl font-bold mb-1" style={{ color: '#F59E0B' }}>
                  알레르겐 포함 가능성
                </div>
                <div className="text-sm" style={{ color: '#475569' }}>
                  주의가 필요합니다
                </div>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-2xl p-6 border-2 shadow-sm" style={{ borderColor: '#14B8A6' }}>
            <div className="flex items-start gap-3">
              <div className="w-10 h-10 rounded-xl flex items-center justify-center" style={{ backgroundColor: '#CCFBF1' }}>
                <TrendingDown className="w-5 h-5" style={{ color: '#14B8A6' }} />
              </div>
              <div>
                <div className="text-2xl font-bold mb-1" style={{ color: '#14B8A6' }}>
                  현재 최저가 -8%
                </div>
                <div className="text-sm" style={{ color: '#475569' }}>
                  지금 구매하세요
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* 메인 히어로 콘텐츠 */}
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          <div className="space-y-8">
            <div className="space-y-6">
              <h1 className="text-5xl lg:text-6xl font-bold leading-tight" style={{ color: '#0F172A' }}>
                우리 아이 사료,<br />
                지금 점수는<br />
                몇 점일까요?
              </h1>
              
              <p className="text-lg leading-relaxed" style={{ color: '#475569' }}>
                헤이제노는 사료 성분을 분석하고,<br />
                맞춤 추천과 멀티플랫폼 최저가 비교까지 제공합니다.
              </p>
            </div>

            <div className="flex flex-col sm:flex-row gap-4">
              <button 
                onClick={onOpenModal}
                className="px-8 py-4 rounded-xl text-white font-semibold text-lg shadow-lg hover:shadow-xl transition-all" 
                style={{ backgroundColor: '#2563EB' }}
              >
                우리 아이 사료 점수 확인하기
              </button>
              <button 
                onClick={() => window.open('https://forms.gle/sniAUJaSQktvAjzH6', '_blank')}
                className="px-8 py-4 rounded-xl font-semibold text-lg border-2 hover:bg-gray-50 transition-all" 
                style={{ color: '#2563EB', borderColor: '#2563EB' }}
              >
                출시 알림 받기
              </button>
            </div>
          </div>

          <div className="relative">
            <AppMockup />
          </div>
        </div>
      </div>
    </section>
  );
}