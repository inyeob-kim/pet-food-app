import { ReactNode } from 'react';
import { ArrowLeft } from 'lucide-react';
import { ProgressBar } from './ProgressBar';
import { CTAButton } from './CTAButton';

type OnboardingLayoutProps = {
  currentStep: number;
  totalSteps: number;
  onBack?: () => void;
  emoji: string;
  title: string;
  subtitle?: string;
  children: ReactNode;
  ctaText: string;
  ctaDisabled?: boolean;
  onCTAClick: () => void;
  ctaSecondary?: {
    text: string;
    onClick: () => void;
  };
};

export function OnboardingLayout({
  currentStep,
  totalSteps,
  onBack,
  emoji,
  title,
  subtitle,
  children,
  ctaText,
  ctaDisabled = false,
  onCTAClick,
  ctaSecondary
}: OnboardingLayoutProps) {
  return (
    <div className="bg-white rounded-3xl shadow-sm min-h-[667px] flex flex-col">
      {/* Progress Bar */}
      <div className="px-4 pt-4">
        <ProgressBar current={currentStep} total={totalSteps} />
      </div>

      {/* Back Button */}
      {onBack && (
        <button
          onClick={onBack}
          className="mt-3 ml-4 w-10 h-10 flex items-center justify-center rounded-full hover:bg-gray-100 transition-colors"
          aria-label="Go back"
        >
          <ArrowLeft className="w-5 h-5 text-[#111827]" />
        </button>
      )}

      {/* Scrollable Content Area */}
      <div className="flex-1 overflow-y-auto px-4 pb-4">
        {/* Header */}
        <div className={`${onBack ? 'mt-6' : 'mt-8'} mb-8`}>
          <div className="text-7xl mb-6">{emoji}</div>
          <h1 className="text-2xl font-bold text-[#111827] leading-tight mb-2">
            {title}
          </h1>
          {subtitle && (
            <p className="text-[15px] text-[#6B7280] leading-relaxed">
              {subtitle}
            </p>
          )}
        </div>

        {/* Content */}
        <div className="space-y-6">{children}</div>
      </div>

      {/* Bottom CTA */}
      <div className="p-4 pt-0">
        <div className="pt-4 space-y-3">
          <CTAButton
            onClick={onCTAClick}
            disabled={ctaDisabled}
            variant="primary"
          >
            {ctaText}
          </CTAButton>
          {ctaSecondary && (
            <CTAButton
              onClick={ctaSecondary.onClick}
              variant="secondary"
            >
              {ctaSecondary.text}
            </CTAButton>
          )}
        </div>
      </div>
    </div>
  );
}
