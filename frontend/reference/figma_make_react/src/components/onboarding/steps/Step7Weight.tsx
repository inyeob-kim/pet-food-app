import { OnboardingLayout } from '../OnboardingLayout';
import { TextInput } from '../TextInput';

type Step7WeightProps = {
  value: string;
  onUpdate: (value: string) => void;
  onNext: () => void;
  onBack: () => void;
  currentStep: number;
  totalSteps: number;
};

export function Step7Weight({
  value,
  onUpdate,
  onNext,
  onBack,
  currentStep,
  totalSteps
}: Step7WeightProps) {
  const weight = parseFloat(value);
  const isValid = !isNaN(weight) && weight >= 0.1 && weight <= 99.9;

  return (
    <OnboardingLayout
      currentStep={currentStep}
      totalSteps={totalSteps}
      onBack={onBack}
      emoji="⚖️"
      title="What's your pet's weight?"
      subtitle="Enter their current weight in kilograms"
      ctaText="Continue"
      ctaDisabled={!isValid}
      onCTAClick={onNext}
    >
      <div>
        <label className="block text-sm font-medium text-[#6B7280] mb-2">
          Weight (kg)
        </label>
        <TextInput
          type="number"
          value={value}
          onChange={onUpdate}
          placeholder="0.0"
          step="0.1"
          min="0.1"
          max="99.9"
        />
        <p className="mt-2 text-sm text-[#6B7280]">
          Enter a value between 0.1 and 99.9 kg
        </p>
      </div>
    </OnboardingLayout>
  );
}
