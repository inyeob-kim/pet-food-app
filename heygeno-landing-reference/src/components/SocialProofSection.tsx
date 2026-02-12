import { Search, Shield, BarChart3 } from 'lucide-react';

export function SocialProofSection() {
  const targetUsers = [
    {
      icon: Search,
      title: '성분을 제대로 확인하고 싶은 보호자',
      description: '복잡한 사료 성분표를 정확하게 분석하고 이해하고 싶으신 분들을 위해',
      color: '#2563EB'
    },
    {
      icon: Shield,
      title: '알레르기가 걱정되는 반려가정',
      description: '우리 아이에게 맞지 않는 성분과 알레르겐을 사전에 확인하고 싶으신 분들을 위해',
      color: '#EF4444'
    },
    {
      icon: BarChart3,
      title: '여러 플랫폼 가격을 비교하고 싶은 보호자',
      description: '쿠팡, 네이버 등 다양한 플랫폼의 최저가를 한눈에 비교하고 싶으신 분들을 위해',
      color: '#14B8A6'
    }
  ];

  return (
    <section className="py-24 px-6 lg:px-8 bg-white">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl lg:text-5xl font-bold mb-6" style={{ color: '#0F172A' }}>
            이런 보호자를 위해 만들었습니다.
          </h2>
        </div>

        <div className="grid md:grid-cols-3 gap-8">
          {targetUsers.map((user, index) => (
            <div 
              key={index} 
              className="bg-white rounded-2xl p-8 border-2 border-gray-100 hover:border-gray-200 transition-all"
            >
              <div 
                className="w-14 h-14 rounded-2xl flex items-center justify-center mb-6" 
                style={{ backgroundColor: `${user.color}15` }}
              >
                <user.icon className="w-7 h-7" style={{ color: user.color }} />
              </div>
              <h3 className="text-xl font-bold mb-4 leading-snug" style={{ color: '#0F172A' }}>
                {user.title}
              </h3>
              <p className="leading-relaxed" style={{ color: '#475569' }}>
                {user.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
