import { motion } from 'motion/react';
import { Coins } from 'lucide-react';

const pointTiers = [
  { range: '2만원 미만', points: '150P', color: 'from-gray-400 to-gray-500' },
  { range: '2만원 ~ 4만원', points: '250P', color: 'from-blue-400 to-blue-500' },
  { range: '4만원 ~ 7만원', points: '350P', color: 'from-green-400 to-green-500' },
  { range: '7만원 이상', points: '최대 450P', color: 'from-amber-400 to-amber-500', highlight: true },
];

export function PointsTable() {
  return (
    <section className="py-12 sm:py-16 md:py-20 px-4 sm:px-6 relative bg-gray-50">
      <div className="max-w-4xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-10 sm:mb-12"
        >
          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-amber-100 border border-amber-200 mb-4 sm:mb-6">
            <Coins className="w-4 h-4 text-amber-600" />
            <span className="text-sm text-amber-700">포인트 적립</span>
          </div>
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-bold mb-3 sm:mb-4 text-gray-900">
            사면 살수록 쌓이는 포인트
          </h2>
          <p className="text-base sm:text-xl text-gray-600">
            사료 구매 금액별 포인트 적립
          </p>
        </motion.div>

        {/* Points Tier Cards */}
        <div className="space-y-3 sm:space-y-4 mb-6 sm:mb-8">
          {pointTiers.map((tier, index) => (
            <motion.div
              key={tier.range}
              initial={{ opacity: 0, x: -30 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
            >
              <div className={`relative bg-white border-2 ${
                tier.highlight ? 'border-amber-300 shadow-lg shadow-amber-500/20' : 'border-gray-200'
              } rounded-2xl p-5 sm:p-6 hover:shadow-lg transition-all`}>
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3 sm:gap-4">
                    <div className={`w-10 h-10 sm:w-12 sm:h-12 rounded-xl bg-gradient-to-br ${tier.color} flex items-center justify-center flex-shrink-0`}>
                      <Coins className="w-5 h-5 sm:w-6 sm:h-6 text-white" />
                    </div>
                    <div>
                      <p className="text-base sm:text-lg font-bold text-gray-900">{tier.range}</p>
                    </div>
                  </div>
                  <div className={`text-xl sm:text-2xl font-bold ${
                    tier.highlight ? 'text-amber-600' : 'text-green-600'
                  }`}>
                    {tier.points}
                  </div>
                </div>
                {tier.highlight && (
                  <div className="absolute -top-2 -right-2 px-3 py-1 rounded-full bg-gradient-to-r from-amber-400 to-orange-400 text-white text-xs font-bold shadow-lg">
                    최대 적립
                  </div>
                )}
              </div>
            </motion.div>
          ))}
        </div>

        {/* Supporting Text */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6, delay: 0.4 }}
          className="text-center"
        >
          <p className="text-sm text-gray-500 leading-relaxed">
            구매 금액 구간에 따라 포인트가 적립되며,<br />
            최대 적립 포인트는 450P입니다
          </p>
        </motion.div>
      </div>
    </section>
  );
}
