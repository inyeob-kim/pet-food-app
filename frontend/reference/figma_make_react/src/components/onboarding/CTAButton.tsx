import { ReactNode } from 'react';

type CTAButtonProps = {
  children: ReactNode;
  onClick: () => void;
  disabled?: boolean;
  variant?: 'primary' | 'secondary';
};

export function CTAButton({
  children,
  onClick,
  disabled = false,
  variant = 'primary'
}: CTAButtonProps) {
  const baseStyles = 'w-full h-14 rounded-2xl font-semibold text-[15px] transition-all duration-200';
  
  const variantStyles = variant === 'primary'
    ? 'bg-[#2563EB] text-white hover:bg-[#1d4ed8] active:scale-[0.98] disabled:bg-[#E5E7EB] disabled:text-[#6B7280] disabled:cursor-not-allowed'
    : 'bg-white text-[#111827] border-2 border-[#E5E7EB] hover:border-[#2563EB] hover:text-[#2563EB] active:scale-[0.98]';

  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`${baseStyles} ${variantStyles}`}
    >
      {children}
    </button>
  );
}
