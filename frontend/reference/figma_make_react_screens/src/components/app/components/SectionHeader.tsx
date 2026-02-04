import { ChevronRight } from 'lucide-react';

type SectionHeaderProps = {
  title: string;
  subtitle?: string;
  onViewAll?: () => void;
};

export function SectionHeader({ title, subtitle, onViewAll }: SectionHeaderProps) {
  return (
    <div className="flex items-center justify-between">
      <div>
        <h2 className="text-title text-[#111827]">{title}</h2>
        {subtitle && (
          <p className="text-sub text-[#6B7280] mt-1">{subtitle}</p>
        )}
      </div>
      {onViewAll && (
        <button
          onClick={onViewAll}
          className="flex items-center gap-1 text-sub text-[#6B7280] hover:text-[#2563EB] active:scale-95 transition-all"
        >
          <span>View all</span>
          <ChevronRight className="w-4 h-4" />
        </button>
      )}
    </div>
  );
}
