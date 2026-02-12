import { ArrowRight } from 'lucide-react';
import { useState } from 'react';
import { AnalysisSimulationModal } from './AnalysisSimulationModal';

export function FinalCTA() {
  const [isModalOpen, setIsModalOpen] = useState(false);

  return (
    <>
      <section id="contact" className="py-32 px-6 lg:px-8 relative overflow-hidden" style={{ backgroundColor: '#1E3A8A' }}>
        {/* Background Pattern */}
        <div className="absolute inset-0 opacity-10">
          <div className="absolute top-0 left-0 w-96 h-96 rounded-full" style={{ background: 'radial-gradient(circle, #60A5FA 0%, transparent 70%)' }}></div>
          <div className="absolute bottom-0 right-0 w-96 h-96 rounded-full" style={{ background: 'radial-gradient(circle, #14B8A6 0%, transparent 70%)' }}></div>
        </div>

        <div className="max-w-4xl mx-auto text-center relative z-10">
          <h2 className="text-4xl lg:text-6xl font-bold text-white mb-8 leading-tight">
            지금, 우리 아이 사료를<br />
            분석해보세요.
          </h2>
          
          <p className="text-xl text-blue-100 mb-12 max-w-2xl mx-auto">
            5분이면 충분합니다.<br />
            과학적인 성분 분석과 맞춤 추천을 무료로 경험하세요.
          </p>

          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
            <button 
              onClick={() => setIsModalOpen(true)}
              className="group px-10 py-5 bg-white rounded-xl font-semibold text-lg shadow-xl hover:shadow-2xl transition-all flex items-center gap-3" 
              style={{ color: '#1E3A8A' }}
            >
              분석 시뮬레이션 보기
              <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
            </button>
            
            <a
              href="https://forms.gle/sniAUJaSQktvAjzH6"
              target="_blank"
              rel="noopener noreferrer"
              className="px-10 py-5 rounded-xl font-semibold text-lg border-2 border-white text-white hover:bg-white/10 transition-all"
            >
              사전 등록하기
            </a>
          </div>

          <div className="mt-16 flex flex-wrap justify-center gap-8 text-white/80">
            <div className="text-center">
              <div className="text-3xl font-bold text-white mb-1">10,000+</div>
              <div className="text-sm">분석 완료</div>
            </div>
            <div className="text-center">
              <div className="text-3xl font-bold text-white mb-1">500+</div>
              <div className="text-sm">등록 제품</div>
            </div>
            <div className="text-center">
              <div className="text-3xl font-bold text-white mb-1">4.8/5.0</div>
              <div className="text-sm">사용자 평점</div>
            </div>
          </div>
        </div>
      </section>

      <AnalysisSimulationModal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} />
    </>
  );
}