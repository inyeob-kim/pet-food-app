import { Heart, Bell } from 'lucide-react';
import { AppBar } from '../components/AppBar';
import { PrimaryButton } from '../components/PrimaryButton';

type ProductDetailScreenProps = {
  product: any;
  onBack: () => void;
};

export function ProductDetailScreen({ product, onBack }: ProductDetailScreenProps) {
  const discount = product.comparePrice 
    ? Math.round(((product.comparePrice - product.price) / product.comparePrice) * 100)
    : 0;

  return (
    <div className="min-h-screen bg-white">
      <AppBar title="Product Detail" onBack={onBack} />
      
      <div className="pb-24">
        {/* Product Hero */}
        <div className="relative">
          <img 
            src={product.image}
            alt={product.name}
            className="w-full h-80 object-cover"
          />
          <button className="absolute top-4 right-4 w-12 h-12 rounded-full bg-white/90 backdrop-blur-sm flex items-center justify-center active:scale-95 transition-all">
            <Heart className={`w-6 h-6 ${product.isWatched ? 'text-[#EF4444] fill-[#EF4444]' : 'text-[#6B7280]'}`} />
          </button>
        </div>

        <div className="px-4 space-y-8 pt-6">
          {/* Product Info */}
          <div>
            <p className="text-sub text-[#6B7280] mb-2">{product.brand}</p>
            <h1 className="text-title text-[#111827] mb-4">{product.name}</h1>
            
            {/* Price - Strongest Visual Element */}
            <div className="flex items-baseline gap-3 mb-2">
              {discount > 0 && (
                <span className="text-[28px] font-bold text-[#EF4444]">{discount}%</span>
              )}
              <span className="text-[32px] font-bold text-[#111827]">
                {product.price.toLocaleString()}원
              </span>
            </div>
            {product.comparePrice && (
              <p className="text-body text-[#6B7280] line-through">
                {product.comparePrice.toLocaleString()}원
              </p>
            )}
          </div>

          {/* Price Comparison Message */}
          <div className="p-4 rounded-2xl bg-[#EFF6FF]">
            <p className="text-body text-[#2563EB]">
              💰 This is 18% lower than average market price
            </p>
          </div>

          {/* Price Graph Section */}
          <div>
            <h3 className="text-body text-[#111827] mb-4">Price History</h3>
            <div className="h-40 rounded-2xl bg-[#F7F8FA] flex items-center justify-center">
              <p className="text-sub text-[#6B7280]">Price graph placeholder</p>
            </div>
          </div>

          {/* Alert CTA Section */}
          <div className="p-4 rounded-2xl bg-[#F7F8FA]">
            <div className="flex items-start gap-3 mb-3">
              <div className="w-10 h-10 rounded-full bg-white flex items-center justify-center flex-shrink-0">
                <Bell className="w-5 h-5 text-[#2563EB]" />
              </div>
              <div className="flex-1">
                <h3 className="text-body text-[#111827] mb-1">Price Alert</h3>
                <p className="text-sub text-[#6B7280]">
                  Get notified when price drops below your target
                </p>
              </div>
            </div>
            <PrimaryButton variant="small" onClick={() => {}}>
              Set alert
            </PrimaryButton>
          </div>

          {/* Ingredient Analysis */}
          <div>
            <h3 className="text-body text-[#111827] mb-4">Nutritional Analysis</h3>
            <div className="space-y-3">
              <div className="flex items-center justify-between p-3 rounded-xl bg-[#F7F8FA]">
                <span className="text-body text-[#111827]">Protein</span>
                <span className="text-body text-[#2563EB] font-semibold">{product.protein}</span>
              </div>
              <div className="flex items-center justify-between p-3 rounded-xl bg-[#F7F8FA]">
                <span className="text-body text-[#111827]">Fat</span>
                <span className="text-body text-[#2563EB] font-semibold">{product.fat}</span>
              </div>
              <div className="flex items-center justify-between p-3 rounded-xl bg-[#F7F8FA]">
                <span className="text-body text-[#111827]">Fiber</span>
                <span className="text-body text-[#2563EB] font-semibold">{product.fiber}</span>
              </div>
            </div>

            <div className="mt-4 p-4 rounded-2xl bg-[#F0FDF4] border border-[#16A34A]/20">
              <p className="text-body text-[#16A34A]">
                ✓ Suitable for Max based on nutritional requirements
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Sticky Bottom Bar */}
      <div className="fixed bottom-0 left-0 right-0 max-w-[375px] mx-auto bg-white border-t border-[#F7F8FA] p-4">
        <div className="flex gap-3">
          <button className="w-14 h-[56px] rounded-[18px] bg-[#F7F8FA] flex items-center justify-center active:scale-95 transition-all">
            <Heart className={`w-6 h-6 ${product.isWatched ? 'text-[#EF4444] fill-[#EF4444]' : 'text-[#111827]'}`} />
          </button>
          <div className="flex-1">
            <PrimaryButton onClick={() => {}}>
              Buy now
            </PrimaryButton>
          </div>
        </div>
      </div>
    </div>
  );
}
