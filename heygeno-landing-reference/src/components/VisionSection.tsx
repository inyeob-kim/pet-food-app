import { Pill, FileText, Database } from 'lucide-react';

export function VisionSection() {
  const visions = [
    {
      icon: Pill,
      title: '영양제 추천',
      description: '반려동물 맞춤 영양제 분석 및 추천 시스템'
    },
    {
      icon: FileText,
      title: '건강 리포트',
      description: '누적 데이터 기반 건강 상태 분석 리포트'
    },
    {
      icon: Database,
      title: '데이터 플랫폼',
      description: '펫 헬스케어 데이터 통합 관리 시스템'
    }
  ];

  return (
    <section id="about" className="py-24 px-6 lg:px-8 bg-white">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl lg:text-5xl font-bold mb-6" style={{ color: '#0F172A' }}>
            우리는 반려동물 뉴트리션의<br />
            기준을 만듭니다.
          </h2>
          <p className="text-xl max-w-3xl mx-auto" style={{ color: '#475569' }}>
            헤이제노는 단순한 사료 추천을 넘어,<br />
            데이터 기반 헬스케어 플랫폼으로 진화합니다.
          </p>
        </div>

        <div className="grid md:grid-cols-3 gap-8 mb-16">
          {visions.map((vision, index) => (
            <div key={index} className="text-center">
              <div className="w-20 h-20 rounded-2xl flex items-center justify-center mx-auto mb-6" style={{ backgroundColor: '#EFF6FF' }}>
                <vision.icon className="w-10 h-10" style={{ color: '#2563EB' }} />
              </div>
              <h3 className="text-xl font-bold mb-3" style={{ color: '#0F172A' }}>
                {vision.title}
              </h3>
              <p style={{ color: '#475569' }}>
                {vision.description}
              </p>
            </div>
          ))}
        </div>

        <div className="bg-gradient-to-br from-blue-50 to-teal-50 rounded-3xl p-12 text-center">
          <div className="max-w-3xl mx-auto space-y-6">
            <div className="inline-block px-4 py-2 rounded-full text-sm font-semibold mb-4" style={{ backgroundColor: '#2563EB', color: 'white' }}>
              확장 가능성
            </div>
            <h3 className="text-3xl font-bold mb-4" style={{ color: '#0F172A' }}>
              장기적으로 성장하는<br />데이터 기반 플랫폼
            </h3>
            <p className="text-lg" style={{ color: '#475569' }}>
              사료 분석부터 시작하여, 영양제, 건강 관리까지<br />
              우리 아이의 전체 라이프사이클을 책임지는 플랫폼으로 발전합니다.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
}