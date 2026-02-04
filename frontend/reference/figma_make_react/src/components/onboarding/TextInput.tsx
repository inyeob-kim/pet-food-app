import { ChangeEvent } from 'react';

type TextInputProps = {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  maxLength?: number;
  type?: 'text' | 'number' | 'date';
  step?: string;
  min?: string;
  max?: string;
};

export function TextInput({
  value,
  onChange,
  placeholder = '',
  maxLength,
  type = 'text',
  step,
  min,
  max
}: TextInputProps) {
  const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
    onChange(e.target.value);
  };

  return (
    <div className="relative">
      <input
        type={type}
        value={value}
        onChange={handleChange}
        placeholder={placeholder}
        maxLength={maxLength}
        step={step}
        min={min}
        max={max}
        className="w-full h-14 px-4 bg-[#F7F8FA] border-2 border-transparent rounded-xl text-[15px] text-[#111827] placeholder:text-[#6B7280] focus:border-[#2563EB] focus:bg-white outline-none transition-all duration-200"
      />
      {maxLength && (
        <div className="absolute right-4 top-1/2 -translate-y-1/2 text-sm text-[#6B7280]">
          {value.length}/{maxLength}
        </div>
      )}
    </div>
  );
}
