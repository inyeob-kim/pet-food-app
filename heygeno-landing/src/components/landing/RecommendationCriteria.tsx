import { motion } from 'motion/react';
import { ShieldCheck, Scale, Heart, Calculator } from 'lucide-react';

const criteria = [
  {
    icon: ShieldCheck,
    title: '알레르기부터 먼저 제외',
    description: '우리 아이 알레르기 성분이 하나라도 포함된 사료는 추천에서 자동 제외합니다',
  },
  {
    icon: Scale,
    title: '나이·체중에 맞지 않으면 밀려납니다',
    description: '강아지에게 노견용, 노견에게 고칼로리 사료는 추천 우선순위에서 내려갑니다',
  },
  {
    icon: Heart,
    title: '건강 고민은 더 중요하게 반영',
    description: '비만, 관절, 피부, 소화 고민이 있다면 관련 성분이 있는 사료를 더 높게 추천합니다',
  },
  {
    icon: Calculator,
    title: '실제로 먹일 수 있는지도 계산합니다',
    description: '체중과 활동량을 기준으로 하루 급여량과 칼로리를 계산해 현실적인 사료만 추천합니다',
  },
];

export function RecommendationCriteria() {
  return (
    <section className="py-12 sm:py-16 md:py-20 px-4 sm:px-6 relative bg-gray-50">
      <div className="max-w-6xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-10 sm:mb-14"
        >
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-bold mb-2 sm:mb-3 text-gray-900">
            헤이제노는 이렇게 추천합니다
          </h2>
          <p className="text-sm sm:text-base text-gray-500">
            광고보다, 우리 아이 기준을 먼저 봅니다
          </p>
        </motion.div>

        <div className="grid sm:grid-cols-2 gap-5 sm:gap-7 mb-8 sm:mb-10">
          {criteria.map((item, index) => {
            const Icon = item.icon;
            return (
              <motion.div
                key={item.title}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: index * 0.1 }}
              >
                <div className="h-full bg-white border-2 border-gray-200 rounded-3xl p-6 sm:p-8 hover:border-green-300 hover:shadow-lg transition-all">
                  <div className="flex items-start gap-4 sm:gap-5">
                    {/* Icon */}
                    <div className="flex-shrink-0 w-12 h-12 sm:w-14 sm:h-14 rounded-xl bg-green-100 flex items-center justify-center">
                      <Icon className="w-6 h-6 sm:w-7 sm:h-7 text-green-600" />
                    </div>

                    {/* Content */}
                    <div className="flex-1 min-w-0">
                      <h3 className="text-base sm:text-lg md:text-xl font-bold text-gray-900 mb-2 leading-snug">
                        {item.title}
                      </h3>
                      <p className="text-sm sm:text-base text-gray-600 leading-relaxed">
                        {item.description}
                      </p>
                    </div>
                  </div>
                </div>
              </motion.div>
            );
          })}
        </div>

        {/* Trust Message */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6, delay: 0.4 }}
          className="text-center"
        >
          <p className="text-sm sm:text-base text-gray-500 leading-relaxed">
            헤이제노는 단순 인기순이 아닌,<br className="sm:hidden" />
            안전성과 적합성을 기준으로 추천합니다
          </p>
        </motion.div>
      </div>
    </section>
  );
}