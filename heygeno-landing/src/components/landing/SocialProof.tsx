import { motion } from 'motion/react';
import { Star, TrendingDown, Heart } from 'lucide-react';

const testimonials = [
  {
    name: '김서윤',
    pet: '말티즈 · 5살',
    comment: '비싼 사료라 항상 고민됐는데, 혜택까지 있으니 헤이제노로 사는 게 습관이 됐어요.',
    rating: 5,
    avatar: '🐕',
  },
  {
    name: '박지훈',
    pet: '페르시안 고양이 · 2살',
    comment: '알레르기 검사받고 사료 고르는데 한참 걸렸는데, 이제는 앱에서 바로 확인하고 포인트까지 받아요.',
    rating: 5,
    avatar: '🐱',
  },
  {
    name: '이수진',
    pet: '골든 리트리버 · 7살',
    comment: '최저가 알림 덕분에 놓칠 뻔한 할인 받았어요. 포인트로 다음 구매 때 쿠폰까지 받았습니다!',
    rating: 5,
    avatar: '🐕',
  },
];

export function SocialProof() {
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
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-bold mb-3 sm:mb-4 text-gray-900">
            반려인들의 이야기
          </h2>
          <p className="text-base sm:text-xl text-gray-600">
            실제 보호자들의 생생한 후기
          </p>
        </motion.div>

        {/* Testimonials */}
        <div className="space-y-4 sm:space-y-0 sm:grid sm:grid-cols-3 sm:gap-4 md:gap-6 mb-10 sm:mb-12">
          {testimonials.map((testimonial, index) => (
            <motion.div
              key={testimonial.name}
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
            >
              <div className="h-full bg-white border-2 border-gray-200 rounded-3xl p-5 sm:p-6 hover:border-green-300 hover:shadow-xl hover:shadow-green-500/10 transition-all">
                {/* Rating */}
                <div className="flex gap-1 mb-3 sm:mb-4">
                  {[...Array(testimonial.rating)].map((_, i) => (
                    <Star key={i} className="w-4 h-4 fill-amber-400 text-amber-400" />
                  ))}
                </div>

                {/* Comment */}
                <p className="text-sm sm:text-base text-gray-700 mb-4 sm:mb-6 leading-relaxed">
                  "{testimonial.comment}"
                </p>

                {/* User Info */}
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 sm:w-12 sm:h-12 rounded-full bg-gradient-to-br from-green-400 to-emerald-400 flex items-center justify-center text-xl sm:text-2xl">
                    {testimonial.avatar}
                  </div>
                  <div>
                    <p className="text-sm sm:text-base font-semibold text-gray-900">{testimonial.name}</p>
                    <p className="text-xs sm:text-sm text-gray-600">{testimonial.pet}</p>
                  </div>
                </div>
              </div>
            </motion.div>
          ))}
        </div>

        {/* Stats */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6, delay: 0.3 }}
          className="grid grid-cols-3 gap-4 sm:gap-8"
        >
          <div className="text-center p-4 sm:p-6 rounded-2xl bg-white border-2 border-gray-200">
            <div className="w-8 h-8 sm:w-10 sm:h-10 rounded-xl bg-green-100 flex items-center justify-center mx-auto mb-2 sm:mb-3">
              <Heart className="w-4 h-4 sm:w-5 sm:h-5 text-green-600 fill-green-600" />
            </div>
            <div className="text-2xl sm:text-3xl md:text-4xl font-bold text-green-600 mb-1">
              12,000+
            </div>
            <p className="text-xs sm:text-sm text-gray-600">반려동물</p>
          </div>
          <div className="text-center p-4 sm:p-6 rounded-2xl bg-white border-2 border-gray-200">
            <div className="w-8 h-8 sm:w-10 sm:h-10 rounded-xl bg-amber-100 flex items-center justify-center mx-auto mb-2 sm:mb-3">
              <Star className="w-4 h-4 sm:w-5 sm:h-5 text-amber-600 fill-amber-600" />
            </div>
            <div className="text-2xl sm:text-3xl md:text-4xl font-bold text-amber-600 mb-1">
              4.9
            </div>
            <p className="text-xs sm:text-sm text-gray-600">평균 평점</p>
          </div>
          <div className="text-center p-4 sm:p-6 rounded-2xl bg-white border-2 border-gray-200">
            <div className="w-8 h-8 sm:w-10 sm:h-10 rounded-xl bg-blue-100 flex items-center justify-center mx-auto mb-2 sm:mb-3">
              <TrendingDown className="w-4 h-4 sm:w-5 sm:h-5 text-blue-600" />
            </div>
            <div className="text-2xl sm:text-3xl md:text-4xl font-bold text-blue-600 mb-1">
              ₩850만
            </div>
            <p className="text-xs sm:text-sm text-gray-600">누적 구매</p>
          </div>
        </motion.div>
      </div>
    </section>
  );
}