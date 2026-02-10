import { motion } from 'motion/react';
import { TrendingDown, CheckCircle } from 'lucide-react';

const platforms = [
  { name: '쿠팡', logo: '🛒' },
  { name: '네이버', logo: '🟢' },
  { name: '11번가', logo: '🛍️' },
  { name: '옥션', logo: '🏪' },
];

export function MultiPlatformSection() {
  return (
    <section className="py-12 sm:py-16 md:py-20 px-4 sm:px-6 relative bg-white">
      <div className="max-w-6xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-10 sm:mb-14"
        >
          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-blue-50 border border-blue-200 mb-4 sm:mb-6">
            <TrendingDown className="w-4 h-4 text-blue-600" />
            <span className="text-sm text-blue-700">멀티플랫폼 최저가 비교</span>
          </div>
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-bold mb-3 sm:mb-4 text-gray-900">
            여러 쇼핑몰을 한 번에 비교합니다
          </h2>
          <p className="text-base sm:text-xl text-gray-600">
            일일이 검색하지 않아도, 진짜 최저가를 찾아드려요
          </p>
        </motion.div>

        {/* Main Price Comparison Card */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="mb-8 sm:mb-10"
        >
          <div className="relative">
            <div className="absolute inset-0 bg-gradient-to-r from-blue-200/40 to-cyan-200/40 rounded-3xl blur-2xl" />
            <div className="relative bg-white border-2 border-gray-200 rounded-3xl p-6 sm:p-8 shadow-xl">
              {/* Product Info */}
              <div className="mb-6">
                <p className="text-sm text-gray-500 mb-2">추천 사료 예시</p>
                <h3 className="text-xl sm:text-2xl font-bold text-gray-900 mb-1">
                  로얄캐닌 독 미디엄 어덜트 15kg
                </h3>
                <p className="text-sm text-gray-600">중형견 성견용 사료</p>
              </div>

              {/* Platform Prices */}
              <div className="space-y-3 mb-6">
                <div className="flex items-center justify-between p-4 rounded-xl bg-green-50 border-2 border-green-500">
                  <div className="flex items-center gap-3">
                    <div className="text-2xl">🛒</div>
                    <div>
                      <p className="text-sm font-semibold text-gray-900">쿠팡</p>
                      <div className="flex items-center gap-2">
                        <span className="text-lg font-bold text-green-600">89,900원</span>
                        <span className="text-xs text-green-600 font-semibold">최저가</span>
                      </div>
                    </div>
                  </div>
                  <CheckCircle className="w-6 h-6 text-green-600" />
                </div>

                <div className="flex items-center justify-between p-4 rounded-xl bg-gray-50 border border-gray-200">
                  <div className="flex items-center gap-3">
                    <div className="text-2xl">🟢</div>
                    <div>
                      <p className="text-sm font-semibold text-gray-900">네이버스토어</p>
                      <span className="text-lg font-bold text-gray-700">94,500원</span>
                    </div>
                  </div>
                  <span className="text-sm text-gray-500">+4,600원</span>
                </div>

                <div className="flex items-center justify-between p-4 rounded-xl bg-gray-50 border border-gray-200">
                  <div className="flex items-center gap-3">
                    <div className="text-2xl">🛍️</div>
                    <div>
                      <p className="text-sm font-semibold text-gray-900">11번가</p>
                      <span className="text-lg font-bold text-gray-700">96,800원</span>
                    </div>
                  </div>
                  <span className="text-sm text-gray-500">+6,900원</span>
                </div>

                <div className="flex items-center justify-between p-4 rounded-xl bg-gray-50 border border-gray-200">
                  <div className="flex items-center gap-3">
                    <div className="text-2xl">🏪</div>
                    <div>
                      <p className="text-sm font-semibold text-gray-900">옥션</p>
                      <span className="text-lg font-bold text-gray-700">98,000원</span>
                    </div>
                  </div>
                  <span className="text-sm text-gray-500">+8,100원</span>
                </div>
              </div>

              {/* Alert Setting */}
              <div className="flex items-center justify-between p-5 rounded-xl bg-gradient-to-br from-blue-50 to-cyan-50 border border-blue-200">
                <div>
                  <p className="text-sm font-semibold text-gray-900 mb-1">최저가 알림 설정됨</p>
                  <p className="text-xs text-gray-600">가격 하락 시 바로 알림을 드려요</p>
                </div>
                <div className="w-10 h-10 rounded-full bg-blue-500 flex items-center justify-center">
                  <CheckCircle className="w-6 h-6 text-white" />
                </div>
              </div>
            </div>
          </div>
        </motion.div>

        {/* Platform Badges */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6, delay: 0.3 }}
          className="text-center"
        >
          <p className="text-sm text-gray-500 mb-4">지원 쇼핑몰</p>
          <div className="flex flex-wrap items-center justify-center gap-3">
            {platforms.map((platform, index) => (
              <motion.div
                key={platform.name}
                initial={{ opacity: 0, scale: 0.9 }}
                whileInView={{ opacity: 1, scale: 1 }}
                viewport={{ once: true }}
                transition={{ duration: 0.3, delay: 0.4 + index * 0.1 }}
                className="flex items-center gap-2 px-4 py-2 rounded-full bg-white border border-gray-200"
              >
                <span className="text-lg">{platform.logo}</span>
                <span className="text-sm font-semibold text-gray-700">{platform.name}</span>
              </motion.div>
            ))}
            <div className="flex items-center gap-2 px-4 py-2 rounded-full bg-gray-100 border border-gray-200">
              <span className="text-sm font-semibold text-gray-500">+더 많은 쇼핑몰</span>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  );
}
