import { Award, ShoppingCart, Star, Gift } from 'lucide-react';
import { useLanguage } from '../contexts/LanguageContext';

export function RewardSection() {
  const { t } = useLanguage();
  
  return (
    <section className="py-16 sm:py-20 lg:py-24 px-4 sm:px-6 lg:px-8 w-full overflow-x-hidden" style={{ backgroundColor: '#EFF6FF' }}>
      <div className="max-w-7xl mx-auto w-full">
        <div className="grid lg:grid-cols-2 gap-12 sm:gap-16 items-center w-full">
          <div className="space-y-6 sm:space-y-8 w-full">
            <div className="space-y-4 sm:space-y-6">
              <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold leading-tight" style={{ color: '#0F172A' }}>
                {t('reward.main.title').split('\\n').map((line, i) => (
                  <span key={i}>
                    {line}
                    {i === 0 && <br />}
                  </span>
                ))}
              </h2>
              
              <p className="text-base sm:text-lg leading-relaxed" style={{ color: '#475569' }}>
                {t('reward.main.desc')}
              </p>
            </div>

            <div className="space-y-4 w-full">
              <div className="flex items-start gap-3 sm:gap-4">
                <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-xl flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#14B8A6' }}>
                  <ShoppingCart className="w-4 h-4 sm:w-5 sm:h-5 text-white" />
                </div>
                <div className="min-w-0 flex-1">
                  <div className="font-semibold mb-1 text-sm sm:text-base" style={{ color: '#0F172A' }}>
                    {t('reward.earn1.title')}
                  </div>
                  <div className="text-xs sm:text-sm" style={{ color: '#475569' }}>
                    {t('reward.earn1.desc')}
                  </div>
                </div>
              </div>

              <div className="flex items-start gap-3 sm:gap-4">
                <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-xl flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#14B8A6' }}>
                  <Star className="w-4 h-4 sm:w-5 sm:h-5 text-white" />
                </div>
                <div className="min-w-0 flex-1">
                  <div className="font-semibold mb-1 text-sm sm:text-base" style={{ color: '#0F172A' }}>
                    {t('reward.earn2.title')}
                  </div>
                  <div className="text-xs sm:text-sm" style={{ color: '#475569' }}>
                    {t('reward.earn2.desc')}
                  </div>
                </div>
              </div>

              <div className="flex items-start gap-3 sm:gap-4">
                <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-xl flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#14B8A6' }}>
                  <Gift className="w-4 h-4 sm:w-5 sm:h-5 text-white" />
                </div>
                <div className="min-w-0 flex-1">
                  <div className="font-semibold mb-1 text-sm sm:text-base" style={{ color: '#0F172A' }}>
                    {t('reward.earn3.title')}
                  </div>
                  <div className="text-xs sm:text-sm" style={{ color: '#475569' }}>
                    {t('reward.earn3.desc')}
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="relative w-full">
            <div className="bg-white rounded-2xl sm:rounded-3xl shadow-2xl p-6 sm:p-8 w-full max-w-lg mx-auto">
              <div className="flex items-center justify-between mb-6 sm:mb-8">
                <div>
                  <div className="text-xs sm:text-sm font-medium mb-1 sm:mb-2" style={{ color: '#475569' }}>
                    {t('reward.card.mypoints')}
                  </div>
                  <div className="text-3xl sm:text-4xl lg:text-5xl font-bold" style={{ color: '#2563EB' }}>
                    12,850P
                  </div>
                </div>
                <div className="w-12 h-12 sm:w-16 sm:h-16 rounded-xl sm:rounded-2xl flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#EFF6FF' }}>
                  <Award className="w-7 h-7 sm:w-9 sm:h-9" style={{ color: '#2563EB' }} />
                </div>
              </div>

              <div className="space-y-4 w-full">
                <div className="bg-gradient-to-r from-blue-50 to-teal-50 rounded-xl sm:rounded-2xl p-4 sm:p-5">
                  <div className="flex items-center justify-between mb-2 sm:mb-3">
                    <div className="text-xs sm:text-sm font-semibold" style={{ color: '#0F172A' }}>
                      {t('reward.card.recentearnings')}
                    </div>
                    <div className="text-xs font-medium" style={{ color: '#475569' }}>
                      {t('reward.card.today')}
                    </div>
                  </div>
                  <div className="space-y-2">
                    <div className="flex items-center justify-between text-xs sm:text-sm">
                      <span style={{ color: '#475569' }}>{t('reward.card.purchase')}</span>
                      <span className="font-semibold" style={{ color: '#14B8A6' }}>+850P</span>
                    </div>
                    <div className="flex items-center justify-between text-xs sm:text-sm">
                      <span style={{ color: '#475569' }}>{t('reward.card.review')}</span>
                      <span className="font-semibold" style={{ color: '#14B8A6' }}>+500P</span>
                    </div>
                  </div>
                </div>

                <div className="bg-gray-50 rounded-xl sm:rounded-2xl p-4 sm:p-5">
                  <div className="text-xs sm:text-sm font-semibold mb-2 sm:mb-3" style={{ color: '#0F172A' }}>
                    {t('reward.card.redeemable')}
                  </div>
                  <div className="space-y-2">
                    <div className="flex items-center justify-between text-xs sm:text-sm">
                      <span style={{ color: '#475569' }}>{t('reward.card.food2kg')}</span>
                      <span className="font-semibold" style={{ color: '#2563EB' }}>10,000P</span>
                    </div>
                    <div className="flex items-center justify-between text-xs sm:text-sm">
                      <span style={{ color: '#475569' }}>{t('reward.card.treats')}</span>
                      <span className="font-semibold" style={{ color: '#2563EB' }}>5,000P</span>
                    </div>
                  </div>
                </div>
              </div>

              <button className="w-full mt-5 sm:mt-6 py-3 sm:py-4 rounded-xl text-sm sm:text-base text-white font-semibold hover:opacity-90 transition-opacity" style={{ backgroundColor: '#14B8A6' }}>
                {t('reward.card.button')}
              </button>
            </div>

            {/* Decorative Element */}
            <div className="absolute -z-10 -top-8 -right-8 w-48 h-48 sm:w-64 sm:h-64 rounded-full opacity-20 hidden lg:block" style={{ backgroundColor: '#14B8A6', filter: 'blur(60px)' }}></div>
          </div>
        </div>
      </div>
    </section>
  );
}