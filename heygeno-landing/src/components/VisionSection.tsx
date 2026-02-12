import { Pill, FileText, Database } from 'lucide-react';
import { useLanguage } from '../contexts/LanguageContext';

export function VisionSection() {
  const { t } = useLanguage();
  
  const visions = [
    {
      icon: Pill,
      title: t('vision.feature1.title'),
      description: t('vision.feature1.desc')
    },
    {
      icon: FileText,
      title: t('vision.feature2.title'),
      description: t('vision.feature2.desc')
    },
    {
      icon: Database,
      title: t('vision.feature3.title'),
      description: t('vision.feature3.desc')
    }
  ];

  return (
    <section id="about" className="py-16 sm:py-20 lg:py-24 px-4 sm:px-6 lg:px-8 bg-white w-full overflow-x-hidden">
      <div className="max-w-7xl mx-auto w-full">
        <div className="text-center mb-12 sm:mb-16">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold mb-4 sm:mb-6" style={{ color: '#0F172A' }}>
            {t('vision.title')}
          </h2>
          <p className="text-base sm:text-lg lg:text-xl max-w-3xl mx-auto px-4" style={{ color: '#475569' }}>
            {t('vision.subtitle')}
          </p>
        </div>

        <div className="grid md:grid-cols-3 gap-6 sm:gap-8 mb-12 sm:mb-16 w-full">
          {visions.map((vision, index) => (
            <div key={index} className="text-center w-full">
              <div className="w-16 h-16 sm:w-20 sm:h-20 rounded-2xl flex items-center justify-center mx-auto mb-4 sm:mb-6" style={{ backgroundColor: '#EFF6FF' }}>
                <vision.icon className="w-8 h-8 sm:w-10 sm:h-10" style={{ color: '#2563EB' }} />
              </div>
              <h3 className="text-lg sm:text-xl font-bold mb-2 sm:mb-3" style={{ color: '#0F172A' }}>
                {vision.title}
              </h3>
              <p className="text-sm sm:text-base" style={{ color: '#475569' }}>
                {vision.description}
              </p>
            </div>
          ))}
        </div>

        <div className="bg-gradient-to-br from-blue-50 to-teal-50 rounded-2xl sm:rounded-3xl p-6 sm:p-8 lg:p-12 text-center w-full">
          <div className="max-w-3xl mx-auto space-y-4 sm:space-y-6">
            <div className="inline-block px-3 sm:px-4 py-1.5 sm:py-2 rounded-full text-xs sm:text-sm font-semibold mb-2 sm:mb-4" style={{ backgroundColor: '#2563EB', color: 'white' }}>
              {t('vision.expansion.badge')}
            </div>
            <h3 className="text-2xl sm:text-3xl font-bold mb-3 sm:mb-4" style={{ color: '#0F172A' }}>
              {t('vision.expansion.title').split('\\n').map((line, i) => (
                <span key={i}>
                  {line}
                  {i === 0 && <br />}
                </span>
              ))}
            </h3>
            <p className="text-base sm:text-lg px-4" style={{ color: '#475569' }}>
              {t('vision.expansion.desc').split('\\n').map((line, i) => (
                <span key={i}>
                  {line}
                  {i === 0 && <br />}
                </span>
              ))}
            </p>
          </div>
        </div>
      </div>
    </section>
  );
}