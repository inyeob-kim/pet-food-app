import { useState } from 'react';
import { Globe } from 'lucide-react';

export function Navigation() {
  const [language, setLanguage] = useState<'KOR' | 'ENG'>('KOR');

  return (
    <nav className="fixed top-0 left-0 right-0 bg-white/80 backdrop-blur-lg border-b border-gray-200 z-50">
      <div className="max-w-7xl mx-auto px-6 lg:px-8">
        <div className="flex items-center justify-between h-20">
          <div className="flex items-center">
            <h1 className="text-2xl font-bold" style={{ color: '#2563EB' }}>
              헤이제노
            </h1>
          </div>
          
          <div className="flex items-center gap-8">
            <div className="hidden md:flex items-center gap-6">
              <a href="#features" className="text-sm" style={{ color: '#475569' }}>
                Features
              </a>
              <a href="#about" className="text-sm" style={{ color: '#475569' }}>
                About
              </a>
              <a href="#contact" className="text-sm" style={{ color: '#475569' }}>
                Contact
              </a>
            </div>
            
            <div className="flex items-center gap-2">
              <Globe className="w-4 h-4" style={{ color: '#475569' }} />
              <button
                onClick={() => setLanguage(language === 'KOR' ? 'ENG' : 'KOR')}
                className="text-sm font-medium"
                style={{ color: '#0F172A' }}
              >
                {language === 'KOR' ? 'KOR | ENG' : 'ENG | KOR'}
              </button>
            </div>
          </div>
        </div>
      </div>
    </nav>
  );
}