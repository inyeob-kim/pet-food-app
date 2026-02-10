import { motion } from 'motion/react';
import { ShieldCheck } from 'lucide-react';

export function TrustSection() {
  return (
    <section className="py-12 sm:py-16 px-4 sm:px-6 relative bg-white">
      <div className="max-w-3xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
        >
          <div className="relative">
            <div className="absolute inset-0 bg-gradient-to-r from-green-200/40 to-emerald-200/40 rounded-3xl blur-2xl" />
            <div className="relative bg-gradient-to-br from-green-50 to-emerald-50 border-2 border-green-200 rounded-3xl p-8 sm:p-10 text-center">
              {/* Icon */}
              <div className="w-14 h-14 sm:w-16 sm:h-16 rounded-2xl bg-white border-2 border-green-300 flex items-center justify-center mx-auto mb-6">
                <ShieldCheck className="w-7 h-7 sm:w-8 sm:h-8 text-green-600" />
              </div>

              {/* Main Text */}
              <h3 className="text-xl sm:text-2xl md:text-3xl font-bold text-gray-900 mb-4">
                헤이제노의 포인트와 쿠폰은<br />
                실제 구매 기준으로만 제공됩니다
              </h3>

              {/* Supporting Text */}
              <p className="text-base sm:text-lg text-gray-600">
                과장 없는 혜택, 투명한 운영
              </p>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  );
}
