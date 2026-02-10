import { motion } from 'motion/react';
import { FileText, Ticket, BellRing } from 'lucide-react';

const benefits = [
  {
    icon: FileText,
    title: '프리미엄 성분 분석',
    description: '알레르기·건강 고민 기반\n상세 분석 리포트 열람',
    gradient: 'from-purple-500 to-pink-500',
    bgGradient: 'from-purple-50 to-pink-50',
  },
  {
    icon: Ticket,
    title: '사료 할인 쿠폰',
    description: '포인트 또는 이벤트로\n사료 할인 쿠폰 지급',
    gradient: 'from-green-500 to-emerald-500',
    bgGradient: 'from-green-50 to-emerald-50',
  },
  {
    icon: BellRing,
    title: '우선 최저가 알림',
    description: '인기 사료 가격 하락 시\n우선 알림 제공',
    gradient: 'from-blue-500 to-cyan-500',
    bgGradient: 'from-blue-50 to-cyan-50',
  },
];

export function BenefitsUsage() {
  return (
    <section className="py-12 sm:py-16 md:py-20 px-4 sm:px-6 relative bg-white">
      <div className="max-w-6xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-10 sm:mb-16"
        >
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-bold mb-3 sm:mb-4 text-gray-900">
            포인트 & 쿠폰 혜택은<br className="sm:hidden" /> 이렇게 쓰여요
          </h2>
          <p className="text-base sm:text-xl text-gray-600">
            똑똑한 혜택 활용법
          </p>
        </motion.div>

        <div className="space-y-4 sm:space-y-0 sm:grid sm:grid-cols-3 sm:gap-6 md:gap-8">
          {benefits.map((benefit, index) => {
            const Icon = benefit.icon;
            return (
              <motion.div
                key={benefit.title}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: index * 0.1 }}
                className="group"
              >
                <div className={`h-full bg-gradient-to-br ${benefit.bgGradient} border-2 border-gray-200 rounded-3xl p-6 sm:p-8 hover:border-green-300 hover:shadow-xl hover:shadow-green-500/10 transition-all`}>
                  <div className={`w-12 h-12 sm:w-14 sm:h-14 rounded-2xl bg-gradient-to-br ${benefit.gradient} flex items-center justify-center mb-4 sm:mb-6 group-hover:scale-110 transition-transform shadow-lg`}>
                    <Icon className="w-6 h-6 sm:w-7 sm:h-7 text-white" />
                  </div>
                  
                  <h3 className="text-lg sm:text-xl md:text-2xl font-bold text-gray-900 mb-2 sm:mb-3 leading-tight">
                    {benefit.title}
                  </h3>
                  
                  <p className="text-sm sm:text-base text-gray-600 leading-relaxed whitespace-pre-line">
                    {benefit.description}
                  </p>
                </div>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
