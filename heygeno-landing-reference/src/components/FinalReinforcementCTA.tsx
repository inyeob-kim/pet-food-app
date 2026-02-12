import { Gift } from 'lucide-react';

export function FinalReinforcementCTA() {
  return (
    <section className="py-32 px-6 lg:px-8 relative overflow-hidden" style={{ backgroundColor: '#1E3A8A' }}>
      {/* Background Pattern */}
      <div className="absolute inset-0 opacity-10">
        <div className="absolute top-0 left-0 w-96 h-96 rounded-full" style={{ background: 'radial-gradient(circle, #60A5FA 0%, transparent 70%)' }}></div>
        <div className="absolute bottom-0 right-0 w-96 h-96 rounded-full" style={{ background: 'radial-gradient(circle, #14B8A6 0%, transparent 70%)' }}></div>
      </div>

      <div className="max-w-4xl mx-auto text-center relative z-10">
        <h2 className="text-4xl lg:text-6xl font-bold text-white mb-12 leading-tight">
          출시되면,<br />
          가장 먼저 분석해보세요.
        </h2>

        {/* CTA 버튼 */}
        <div className="mb-8">
          <a
            href="https://forms.gle/sniAUJaSQktvAjzH6"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center justify-center gap-3 px-10 py-5 bg-white rounded-xl font-semibold text-lg shadow-xl hover:shadow-2xl transition-all"
            style={{ color: '#1E3A8A' }}
          >
            <Gift className="w-5 h-5" />
            1,000P 확보하기
          </a>
        </div>

        <p className="text-lg text-blue-100">
          정식 출시 알림과 보너스 포인트 안내를 보내드립니다.
        </p>
      </div>
    </section>
  );
}