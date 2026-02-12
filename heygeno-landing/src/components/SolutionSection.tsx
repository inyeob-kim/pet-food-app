import { Shield, AlertOctagon, Sparkles, BarChart3, BellRing, Coins } from 'lucide-react';
import { useLanguage } from '../contexts/LanguageContext';

interface SolutionSectionProps {
  onOpenPriceModal?: () => void;
  onOpenModal?: () => void;
}

export function SolutionSection({ onOpenPriceModal, onOpenModal }: SolutionSectionProps) {
  const { t } = useLanguage();
  
  const steps = [
    {
      icon: Shield,
      number: '01',
      title: t('solution.step1.title'),
      description: t('solution.step1.desc'),
      color: '#2563EB'
    },
    {
      icon: AlertOctagon,
      number: '02',
      title: t('solution.step2.title'),
      description: t('solution.step2.desc'),
      color: '#EF4444'
    },
    {
      icon: Sparkles,
      number: '03',
      title: t('solution.step3.title'),
      description: t('solution.step3.desc'),
      color: '#14B8A6'
    },
    {
      icon: BarChart3,
      number: '04',
      title: t('solution.step4.title'),
      description: t('solution.step4.desc'),
      color: '#2563EB'
    },
    {
      icon: BellRing,
      number: '05',
      title: t('solution.step5.title'),
      description: t('solution.step5.desc'),
      color: '#14B8A6'
    },
    {
      icon: Coins,
      number: '06',
      title: t('solution.step6.title'),
      description: t('solution.step6.desc'),
      color: '#F59E0B'
    }
  ];

  return (
    <section id="features" className="py-16 sm:py-20 lg:py-24 px-4 sm:px-6 lg:px-8 w-full overflow-x-hidden" style={{ backgroundColor: '#EFF6FF' }}>
      <div className="max-w-7xl mx-auto w-full">
        <div className="text-center mb-16 sm:mb-20">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold mb-6" style={{ color: '#0F172A' }}>
            {t('solution.title')}
          </h2>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8 w-full">
          {steps.map((step, index) => {
            const isClickable = (step.number === '01' && onOpenModal) || (step.number === '05' && onOpenPriceModal);
            const handleClick = (e: React.MouseEvent) => {
              e.stopPropagation();
              if (step.number === '01' && onOpenModal) onOpenModal();
              if (step.number === '05' && onOpenPriceModal) onOpenPriceModal();
            };

            return (
              <div 
                key={index} 
                onClick={isClickable ? handleClick : undefined}
                className={`bg-white rounded-2xl p-6 sm:p-8 shadow-sm hover:shadow-md transition-all w-full ${
                  isClickable ? 'cursor-pointer active:scale-95' : ''
                }`}
              >
                <div className="flex items-start gap-3 sm:gap-4 mb-3 sm:mb-4">
                  <div className="w-10 h-10 sm:w-12 sm:h-12 rounded-xl flex items-center justify-center flex-shrink-0" style={{ backgroundColor: step.color }}>
                    <step.icon className="w-5 h-5 sm:w-6 sm:h-6 text-white" />
                  </div>
                  <div className="text-2xl sm:text-3xl font-bold" style={{ color: '#E5E7EB' }}>
                    {step.number}
                  </div>
                </div>
                <h3 className="text-lg sm:text-xl font-bold mb-2 sm:mb-3" style={{ color: '#0F172A' }}>
                  {step.title}
                </h3>
                <p className="leading-relaxed text-sm sm:text-base" style={{ color: '#475569' }}>
                  {step.description}
                </p>
                {isClickable && (
                  <div className="mt-4 text-xs font-semibold" style={{ color: step.color }}>
                    {t('solution.demo')}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}