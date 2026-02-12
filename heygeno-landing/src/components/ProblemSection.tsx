import { FileQuestion, AlertTriangle, TrendingUp } from 'lucide-react';
import { useLanguage } from '../contexts/LanguageContext';

export function ProblemSection() {
  const { t } = useLanguage();
  
  const problems = [
    {
      icon: FileQuestion,
      title: t('problem.card1.title'),
      description: t('problem.card1.desc')
    },
    {
      icon: AlertTriangle,
      title: t('problem.card2.title'),
      description: t('problem.card2.desc')
    },
    {
      icon: TrendingUp,
      title: t('problem.card3.title'),
      description: t('problem.card3.desc')
    }
  ];

  return (
    <section className="py-16 sm:py-20 lg:py-24 px-4 sm:px-6 lg:px-8 bg-white w-full overflow-x-hidden">
      <div className="max-w-7xl mx-auto w-full">
        <div className="text-center mb-12 sm:mb-16">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold mb-6" style={{ color: '#0F172A' }}>
            {t('problem.title')}
          </h2>
        </div>

        <div className="grid md:grid-cols-3 gap-6 sm:gap-8 w-full">
          {problems.map((problem, index) => (
            <div key={index} className="bg-white rounded-2xl p-6 sm:p-8 border-2 border-gray-100 hover:border-gray-200 transition-all w-full">
              <div className="w-12 h-12 sm:w-14 sm:h-14 rounded-2xl flex items-center justify-center mb-4 sm:mb-6" style={{ backgroundColor: '#EFF6FF' }}>
                <problem.icon className="w-6 h-6 sm:w-7 sm:h-7" style={{ color: '#2563EB' }} />
              </div>
              <h3 className="text-xl sm:text-2xl font-bold mb-3 sm:mb-4" style={{ color: '#0F172A' }}>
                {problem.title}
              </h3>
              <p className="leading-relaxed text-sm sm:text-base" style={{ color: '#475569' }}>
                {problem.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}