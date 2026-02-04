import { ReactNode } from 'react';

type SelectionCardProps = {
  selected: boolean;
  onClick: () => void;
  children: ReactNode;
  emoji?: string;
};

export function SelectionCard({
  selected,
  onClick,
  children,
  emoji
}: SelectionCardProps) {
  return (
    <button
      onClick={onClick}
      className={`w-full min-h-[72px] px-5 py-4 rounded-2xl border-2 transition-all duration-200 active:scale-[0.98] ${
        selected
          ? 'bg-[#EFF6FF] border-[#2563EB]'
          : 'bg-[#F7F8FA] border-transparent hover:border-[#E5E7EB]'
      }`}
    >
      <div className="flex items-center gap-3">
        {emoji && <span className="text-3xl">{emoji}</span>}
        <div className="flex-1 text-left">
          {children}
        </div>
        <div
          className={`w-6 h-6 rounded-full border-2 flex items-center justify-center flex-shrink-0 transition-all duration-200 ${
            selected
              ? 'border-[#2563EB] bg-[#2563EB]'
              : 'border-[#E5E7EB]'
          }`}
        >
          {selected && (
            <svg
              className="w-3.5 h-3.5 text-white"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth={3}
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M5 13l4 4L19 7"
              />
            </svg>
          )}
        </div>
      </div>
    </button>
  );
}
