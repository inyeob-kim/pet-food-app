import { Heart } from 'lucide-react';

export function Footer() {
  return (
    <footer className="py-10 sm:py-12 px-4 sm:px-6 border-t border-gray-200 bg-gray-50">
      <div className="max-w-6xl mx-auto">
        <div className="flex flex-col items-center gap-6 sm:gap-8">
          {/* Logo & Copyright */}
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-xl bg-gradient-to-br from-[#22C55E] to-[#10B981] flex items-center justify-center">
              <Heart className="w-5 h-5 text-white fill-white" />
            </div>
            <div className="text-center sm:text-left">
              <p className="font-bold text-gray-900 text-lg">헤이제노</p>
              <p className="text-xs sm:text-sm text-gray-600">© 2026 헤이제노. All rights reserved.</p>
            </div>
          </div>

          {/* Links */}
          <div className="flex flex-wrap items-center justify-center gap-6 sm:gap-8 text-sm text-gray-600">
            <a href="#" className="hover:text-gray-900 transition-colors">
              이용약관
            </a>
            <a href="#" className="hover:text-gray-900 transition-colors">
              개인정보처리방침
            </a>
            <a href="#" className="hover:text-gray-900 transition-colors">
              문의하기
            </a>
          </div>

          {/* Divider */}
          <div className="w-full border-t border-gray-200 pt-6">
            <p className="text-sm text-gray-500 text-center">
              Made with 💚 for pets and their humans
            </p>
          </div>
        </div>
      </div>
    </footer>
  );
}