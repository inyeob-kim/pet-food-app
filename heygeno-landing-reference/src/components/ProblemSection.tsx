import { FileQuestion, AlertTriangle, TrendingUp } from 'lucide-react';

export function ProblemSection() {
  const problems = [
    {
      icon: FileQuestion,
      title: '성분은 복잡하고',
      description: '수십 가지 성분표를 일일이 분석하기 어렵습니다'
    },
    {
      icon: AlertTriangle,
      title: '알레르겐은 숨겨져 있고',
      description: '우리 아이에게 맞지 않는 성분을 찾기 힘듭니다'
    },
    {
      icon: TrendingUp,
      title: '플랫폼마다 가격은 다릅니다',
      description: '어디서 사야 가장 저렴한지 비교가 복잡합니다'
    }
  ];

  return (
    <section className="py-24 px-6 lg:px-8 bg-white">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl lg:text-5xl font-bold mb-6" style={{ color: '#0F172A' }}>
            사료 선택,<br className="md:hidden" /> 왜 이렇게 어려울까요?
          </h2>
        </div>

        <div className="grid md:grid-cols-3 gap-8">
          {problems.map((problem, index) => (
            <div key={index} className="bg-white rounded-2xl p-8 border-2 border-gray-100 hover:border-gray-200 transition-all">
              <div className="w-14 h-14 rounded-2xl flex items-center justify-center mb-6" style={{ backgroundColor: '#EFF6FF' }}>
                <problem.icon className="w-7 h-7" style={{ color: '#2563EB' }} />
              </div>
              <h3 className="text-2xl font-bold mb-4" style={{ color: '#0F172A' }}>
                {problem.title}
              </h3>
              <p className="leading-relaxed" style={{ color: '#475569' }}>
                {problem.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
