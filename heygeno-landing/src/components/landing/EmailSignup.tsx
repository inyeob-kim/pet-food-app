import { motion } from 'motion/react';
import { Mail, ArrowRight } from 'lucide-react';

export function EmailSignup() {
  const handleClick = () => {
    window.open('https://forms.gle/iY6DvTA6eWL7gLXi8', '_blank');
  };

  return (
    <section id="email-signup" className="py-12 sm:py-16 md:py-20 px-4 sm:px-6 relative bg-[#F8FAF9]">
      <div className="max-w-3xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
        >
          <div className="relative">
            <div className="absolute inset-0 bg-gradient-to-r from-green-200/50 to-emerald-200/50 rounded-3xl blur-3xl" />
            <div className="relative bg-gradient-to-br from-green-50 via-white to-emerald-50 border-2 border-green-200 rounded-3xl p-8 sm:p-12 text-center shadow-2xl shadow-green-500/20">
              {/* Icon */}
              <div className="w-16 h-16 sm:w-20 sm:h-20 rounded-2xl bg-gradient-to-br from-[#22C55E] to-[#10B981] flex items-center justify-center mx-auto mb-6 shadow-lg shadow-green-500/50">
                <Mail className="w-8 h-8 sm:w-10 sm:h-10 text-white" />
              </div>

              {/* Headline */}
              <h2 className="text-2xl sm:text-3xl md:text-4xl font-bold mb-3 sm:mb-4 text-gray-900 leading-tight">
                출시 소식과 중요한 업데이트만<br />
                받아보고 싶다면
              </h2>

              {/* Subtext */}
              <p className="text-base sm:text-lg text-gray-600 mb-8 sm:mb-10">
                이메일을 남겨주세요
              </p>

              {/* CTA Button */}
              <button
                onClick={handleClick}
                className="group w-full sm:w-auto px-8 sm:px-12 py-4 sm:py-5 rounded-2xl bg-gradient-to-r from-[#22C55E] to-[#10B981] text-white text-base sm:text-lg font-bold hover:shadow-2xl hover:shadow-green-500/50 transition-all active:scale-95 flex items-center justify-center gap-2 mx-auto"
              >
                이메일 남기기
                <ArrowRight className="w-5 h-5 sm:w-6 sm:h-6 group-hover:translate-x-1 transition-transform" />
              </button>

              {/* Trust Text */}
              <p className="text-sm text-gray-500 mt-4 sm:mt-6">
                스팸 없음 · 중요한 소식만 전달드립니다
              </p>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  );
}