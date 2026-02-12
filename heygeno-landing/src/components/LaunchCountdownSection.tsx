import { Clock } from 'lucide-react';
import { useLanguage } from '../contexts/LanguageContext';

export function LaunchCountdownSection() {
  const { t } = useLanguage();
  
  return (
    <section className="py-16 sm:py-20 lg:py-24 px-4 sm:px-6 lg:px-8 w-full overflow-x-hidden" style={{ backgroundColor: '#EFF6FF' }}>
      <div className="max-w-4xl mx-auto text-center w-full">
        <div className="space-y-6 sm:space-y-8">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold" style={{ color: '#0F172A' }}>
            {t('countdown.title')}
          </h2>

          <div className="inline-flex items-center gap-3 sm:gap-4 px-8 sm:px-12 py-6 sm:py-8 bg-white rounded-xl sm:rounded-2xl shadow-sm border-2 max-w-full" style={{ borderColor: '#2563EB' }}>
            <Clock className="w-8 h-8 sm:w-10 sm:h-10 flex-shrink-0" style={{ color: '#2563EB' }} />
            <div className="text-left">
              <div className="text-2xl sm:text-3xl lg:text-4xl font-bold mb-1 whitespace-nowrap" style={{ color: '#2563EB' }}>
                {t('countdown.timeframe')}
              </div>
              <div className="text-xs sm:text-sm font-medium whitespace-nowrap" style={{ color: '#475569' }}>
                {t('countdown.launch')}
              </div>
            </div>
          </div>

          <p className="text-base sm:text-lg max-w-2xl mx-auto px-4" style={{ color: '#475569' }}>
            {t('countdown.message')}
          </p>
        </div>
      </div>
    </section>
  );
}