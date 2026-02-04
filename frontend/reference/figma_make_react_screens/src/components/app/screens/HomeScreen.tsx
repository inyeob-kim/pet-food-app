import { AppBar } from '../components/AppBar';
import { SectionHeader } from '../components/SectionHeader';
import { PrimaryButton } from '../components/PrimaryButton';
import { mockProducts, petData } from '../data/mockData';

type HomeScreenProps = {
  onNavigateToProduct: (product: any) => void;
};

export function HomeScreen({ onNavigateToProduct }: HomeScreenProps) {
  const recommendedProduct = mockProducts[0];

  return (
    <div className="pb-6">
      <AppBar title="Home" />
      
      <div className="px-4 space-y-8">
        {/* Pet Summary Section */}
        <div className="pt-6">
          <div className="flex items-start justify-between mb-4">
            <div>
              <h2 className="text-title text-[#111827] mb-1">{petData.name}'s Summary</h2>
              <p className="text-sub text-[#6B7280]">
                {petData.breed}, {petData.age} years old
              </p>
            </div>
            <div className="text-right">
              <div className="text-price text-[#2563EB]">{petData.weight}kg</div>
              <div className="text-sub text-[#6B7280]">Current weight</div>
            </div>
          </div>
          
          <div className="flex gap-3">
            <div className="flex-1 h-16 rounded-2xl bg-[#F7F8FA] flex flex-col items-center justify-center">
              <div className="text-body text-[#111827] font-semibold">BCS {petData.bcs}</div>
              <div className="text-sub text-[#6B7280]">Ideal</div>
            </div>
            <div className="flex-1 h-16 rounded-2xl bg-[#F7F8FA] flex flex-col items-center justify-center">
              <div className="text-body text-[#111827] font-semibold">285</div>
              <div className="text-sub text-[#6B7280]">kcal/day</div>
            </div>
            <div className="flex-1 h-16 rounded-2xl bg-[#F7F8FA] flex flex-col items-center justify-center">
              <div className="text-body text-[#111827] font-semibold">180g</div>
              <div className="text-sub text-[#6B7280]">Food/day</div>
            </div>
          </div>
        </div>

        {/* Recommendation Section */}
        <div>
          <SectionHeader 
            title="Recommended for Max"
            subtitle="Based on age, weight, and activity level"
          />
          
          <div className="mt-6 rounded-2xl overflow-hidden bg-[#F7F8FA]">
            <img 
              src={recommendedProduct.image}
              alt={recommendedProduct.name}
              className="w-full h-48 object-cover"
            />
            <div className="p-4">
              <p className="text-sub text-[#6B7280] mb-1">{recommendedProduct.brand}</p>
              <h3 className="text-body text-[#111827] mb-3">{recommendedProduct.name}</h3>
              
              {/* Price Metric Row */}
              <div className="flex items-center gap-3 mb-4">
                <div>
                  <div className="flex items-center gap-2">
                    <span className="text-[20px] font-bold text-[#EF4444]">18%</span>
                    <span className="text-price text-[#111827]">
                      {recommendedProduct.price.toLocaleString()}원
                    </span>
                  </div>
                  <p className="text-sub text-[#6B7280] line-through">
                    {recommendedProduct.comparePrice?.toLocaleString()}원
                  </p>
                </div>
              </div>

              {/* Conditional Judgment */}
              <div className="p-3 rounded-xl bg-[#EFF6FF] mb-4">
                <p className="text-sub text-[#2563EB]">
                  ✓ This product matches Max's nutritional needs perfectly
                </p>
              </div>

              {/* CTA Button */}
              <PrimaryButton onClick={() => onNavigateToProduct(recommendedProduct)}>
                View details
              </PrimaryButton>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
