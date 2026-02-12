import { Clock } from 'lucide-react';

export function LaunchCountdownSection() {
  return (
    <section className="py-24 px-6 lg:px-8" style={{ backgroundColor: '#EFF6FF' }}>
      <div className="max-w-4xl mx-auto text-center">
        <div className="space-y-8">
          <h2 className="text-4xl lg:text-5xl font-bold" style={{ color: '#0F172A' }}>
            곧 출시됩니다.
          </h2>

          <div className="inline-flex items-center gap-4 px-12 py-8 bg-white rounded-2xl shadow-sm border-2" style={{ borderColor: '#2563EB' }}>
            <Clock className="w-10 h-10" style={{ color: '#2563EB' }} />
            <div className="text-left">
              <div className="text-3xl lg:text-4xl font-bold mb-1" style={{ color: '#2563EB' }}>
                1–2개월 내
              </div>
              <div className="text-sm font-medium" style={{ color: '#475569' }}>
                정식 출시 예정
              </div>
            </div>
          </div>

          <p className="text-lg max-w-2xl mx-auto" style={{ color: '#475569' }}>
            지금 등록하면 가장 먼저 분석 기능을 경험할 수 있습니다.
          </p>
        </div>
      </div>
    </section>
  );
}
