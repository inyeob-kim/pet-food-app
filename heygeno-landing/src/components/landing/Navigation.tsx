import { Heart } from 'lucide-react';

type NavigationProps = {
  scrolled: boolean;
};

export function Navigation({ scrolled }: NavigationProps) {
  const scrollToEmailSignup = () => {
    const emailSection = document.getElementById('email-signup');
    if (emailSection) {
      emailSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  };

  return (
    <nav className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
      scrolled 
        ? 'bg-white/95 backdrop-blur-xl border-b border-gray-200 shadow-sm' 
        : 'bg-white/80 backdrop-blur-xl'
    }`}>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-3 sm:py-4">
        <div className="flex items-center justify-between">
          {/* Logo */}
          <div className="flex items-center gap-2">
            <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-xl bg-gradient-to-br from-[#22C55E] to-[#10B981] flex items-center justify-center">
              <Heart className="w-5 h-5 sm:w-6 sm:h-6 text-white fill-white" />
            </div>
            <span className="text-lg sm:text-xl font-bold text-gray-900">
              헤이제노
            </span>
          </div>

          {/* CTA Button */}
          <button 
            onClick={scrollToEmailSignup}
            className="px-4 py-2 sm:px-5 sm:py-2.5 rounded-xl bg-gradient-to-r from-[#22C55E] to-[#10B981] text-white text-sm font-medium hover:shadow-lg hover:shadow-green-500/50 transition-all active:scale-95"
          >
            시작하기
          </button>
        </div>
      </div>
    </nav>
  );
}