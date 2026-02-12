import { Shield, AlertOctagon, Sparkles, BarChart3, BellRing, Coins } from 'lucide-react';

export function SolutionSection() {
  const steps = [
    {
      icon: Shield,
      number: '01',
      title: '성분 위험 분석',
      description: '유해 성분과 위험 요소를 자동으로 탐지하고 평가합니다',
      color: '#2563EB'
    },
    {
      icon: AlertOctagon,
      number: '02',
      title: '알레르겐 탐지',
      description: '우리 아이에게 위험한 알레르겐을 사전에 경고합니다',
      color: '#EF4444'
    },
    {
      icon: Sparkles,
      number: '03',
      title: '맞춤 영양 매칭',
      description: '나이, 체중, 건강 상태에 최적화된 영양 솔루션을 제공합니다',
      color: '#14B8A6'
    },
    {
      icon: BarChart3,
      number: '04',
      title: '멀티플랫폼 가격 비교',
      description: '주요 플랫폼의 가격을 한눈에 비교하고 분석합니다',
      color: '#2563EB'
    },
    {
      icon: BellRing,
      number: '05',
      title: '최저가 알림',
      description: '원하는 사료의 가격이 떨어지면 실시간으로 알려드립니다',
      color: '#14B8A6'
    },
    {
      icon: Coins,
      number: '06',
      title: '리워드 포인트 시스템',
      description: '구매와 활동으��� 포인트를 적립하고 사료로 교환하세요',
      color: '#F59E0B'
    }
  ];

  return (
    <section className="py-24 px-6 lg:px-8" style={{ backgroundColor: '#EFF6FF' }}>
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-20">
          <h2 className="text-4xl lg:text-5xl font-bold mb-6" style={{ color: '#0F172A' }}>
            헤이제노는 다르게 접근합니다.
          </h2>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {steps.map((step, index) => (
            <div key={index} className="bg-white rounded-2xl p-8 shadow-sm hover:shadow-md transition-all">
              <div className="flex items-start gap-4 mb-4">
                <div className="w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0" style={{ backgroundColor: step.color }}>
                  <step.icon className="w-6 h-6 text-white" />
                </div>
                <div className="text-3xl font-bold" style={{ color: '#E5E7EB' }}>
                  {step.number}
                </div>
              </div>
              <h3 className="text-xl font-bold mb-3" style={{ color: '#0F172A' }}>
                {step.title}
              </h3>
              <p className="leading-relaxed" style={{ color: '#475569' }}>
                {step.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}