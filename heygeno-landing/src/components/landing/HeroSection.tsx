import { ArrowRight, Bell, CheckCircle } from 'lucide-react';
import { motion } from 'motion/react';

export function HeroSection() {
  return (
    <section className="relative pt-20 sm:pt-24 pb-12 sm:pb-16 px-4 sm:px-6 overflow-hidden bg-gradient-to-b from-green-50 to-white">
      {/* Gradient Orb */}
      <div className="absolute top-0 right-0 w-64 sm:w-96 h-64 sm:h-96 bg-green-200/30 rounded-full blur-3xl" />

      <div className="max-w-6xl mx-auto relative z-10">
        {/* Text Content */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="text-center mb-8 sm:mb-10"
        >
          {/* Main Headline */}
          <h1 className="text-3xl sm:text-5xl md:text-6xl font-bold mb-4 sm:mb-6 leading-tight px-4">
            <span className="text-gray-900">
              성분 분석부터 최저가까지,
            </span>
            <br />
            <span className="bg-gradient-to-r from-[#22C55E] to-[#10B981] bg-clip-text text-transparent">
              한 번에
            </span>
          </h1>

          {/* Sub Headline */}
          <p className="text-lg sm:text-xl md:text-2xl text-gray-700 mb-2 sm:mb-3 leading-relaxed px-4">
            어차피 사는 사료,<br />
            더 안전하게, 더 합리적으로
          </p>

          {/* Supporting Text */}
          <p className="text-sm sm:text-base text-gray-500 mb-8 sm:mb-10 px-4">
            반려동물 맞춤 추천 · 알레르기 필터링 · 가격 알림
          </p>

          {/* CTA Buttons */}
          <div className="flex flex-col sm:flex-row gap-3 sm:gap-4 max-w-2xl mx-auto px-4">
            <button className="group w-full sm:flex-1 px-6 sm:px-8 py-4 rounded-2xl bg-gradient-to-r from-[#22C55E] to-[#10B981] text-white text-sm sm:text-base font-semibold hover:shadow-2xl hover:shadow-green-500/50 transition-all active:scale-95 flex items-center justify-center gap-2 whitespace-nowrap">
              우리 아이 맞춤 사료 찾기
              <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
            </button>
            <button className="w-full sm:flex-1 px-6 sm:px-8 py-4 rounded-2xl bg-white border-2 border-gray-200 text-gray-900 text-sm sm:text-base font-semibold hover:border-green-300 hover:bg-green-50 transition-all active:scale-95 flex items-center justify-center gap-2 whitespace-nowrap">
              <Bell className="w-5 h-5" />
              최저가 알림 먼저 받기
            </button>
          </div>

          {/* Trust Badge */}
          <div className="flex items-center justify-center gap-4 mt-4 sm:mt-5 text-sm text-gray-600 px-4">
            <div className="flex items-center gap-1">
              <CheckCircle className="w-4 h-4 text-green-600" />
              <span>회원가입 1분</span>
            </div>
            <div className="w-1 h-1 rounded-full bg-gray-300" />
            <div className="flex items-center gap-1">
              <CheckCircle className="w-4 h-4 text-green-600" />
              <span>카드 등록 없음</span>
            </div>
          </div>
        </motion.div>

        {/* App Preview Card */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
          className="max-w-sm mx-auto"
        >
          <div className="relative">
            {/* Glow */}
            <div className="absolute inset-0 bg-gradient-to-r from-green-300/30 to-emerald-300/30 rounded-3xl blur-2xl" />
            
            {/* Card */}
            <div className="relative bg-white border border-gray-200 rounded-3xl p-6 sm:p-8 shadow-2xl shadow-green-500/10">
              {/* Pet Profile Header */}
              <div className="flex items-start gap-3 mb-6">
                <div className="w-14 h-14 sm:w-16 sm:h-16 rounded-2xl bg-gradient-to-br from-green-400 to-emerald-400 flex items-center justify-center text-2xl sm:text-3xl">
                  🐕
                </div>
                <div className="flex-1">
                  <h3 className="text-xl sm:text-2xl font-bold text-gray-900 mb-1">Max</h3>
                  <p className="text-sm sm:text-base text-gray-600">골든 리트리버 · 3살 · 15.2kg</p>
                </div>
              </div>

              {/* Safety Score */}
              <div className="mb-4">
                <div className="flex items-center justify-between mb-2">
                  <span className="text-sm text-gray-600">성분 안전도</span>
                  <span className="text-lg font-bold text-green-600">92%</span>
                </div>
                <div className="w-full h-3 bg-gray-100 rounded-full overflow-hidden">
                  <motion.div
                    initial={{ width: 0 }}
                    animate={{ width: '92%' }}
                    transition={{ duration: 1, delay: 0.5 }}
                    className="h-full bg-gradient-to-r from-green-500 to-emerald-500 rounded-full"
                  />
                </div>
              </div>

              {/* Price Alert Badge */}
              <div className="flex items-center gap-2 p-3 sm:p-4 rounded-xl bg-green-50 border border-green-200 mb-4">
                <Bell className="w-5 h-5 text-green-600" />
                <span className="text-sm text-green-800">쿠팡·네이버 등 최저가 알림 설정</span>
              </div>

              {/* Recommended Product */}
              <div className="p-4 rounded-xl bg-gradient-to-br from-green-50 to-emerald-50 border border-green-200">
                <p className="text-xs text-gray-600 mb-2">오늘의 추천 사료</p>
                <h4 className="text-sm font-semibold text-gray-900 mb-1">Premium Grain-Free</h4>
                <div className="flex items-baseline gap-2 mb-2">
                  <span className="text-xl font-bold text-gray-900">45,000원</span>
                  <span className="text-xs text-green-600 font-semibold">-18% 최저가</span>
                </div>
                <div className="flex items-center gap-1 text-xs text-green-700">
                  <span className="font-semibold">+350P</span>
                  <span className="text-gray-500">적립 예정</span>
                </div>
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  );
}