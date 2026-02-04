import { useState } from 'react';
import { SectionHeader } from '../components/SectionHeader';
import { SearchBar } from '../components/SearchBar';
import { ProductTile } from '../components/ProductTile';
import { PillChip } from '../components/PillChip';
import { mockProducts } from '../data/mockData';

type MarketScreenProps = {
  onNavigateToProduct: (product: any) => void;
};

export function MarketScreen({ onNavigateToProduct }: MarketScreenProps) {
  const [selectedCategory, setSelectedCategory] = useState('all');
  
  const categories = ['All', 'Dog food', 'Cat food', 'Treats', 'Supplements'];
  const hotDeals = mockProducts.filter(p => p.comparePrice);
  const popular = mockProducts.slice(0, 4);

  return (
    <div className="pb-6">
      {/* Sliver AppBar */}
      <div className="sticky top-0 bg-white z-10">
        <div className="h-14 flex items-center px-4">
          <h1 className="text-body text-[#111827]">Market</h1>
        </div>
        <div className="px-4 pb-4">
          <SearchBar placeholder="Search for products" />
        </div>
      </div>

      <div className="space-y-8">
        {/* Hot Deals Section */}
        <div>
          <div className="px-4 mb-4">
            <SectionHeader title="Hot Deals" subtitle="Limited time offers" />
          </div>
          <div className="flex gap-3 overflow-x-auto px-4 pb-2 scrollbar-hide">
            {hotDeals.map((product) => (
              <ProductTile
                key={product.id}
                product={product}
                onClick={() => onNavigateToProduct(product)}
                layout="horizontal"
              />
            ))}
          </div>
        </div>

        {/* Popular Section */}
        <div>
          <div className="px-4 mb-4">
            <SectionHeader title="Popular" subtitle="Most loved by pets" />
          </div>
          <div className="flex gap-3 overflow-x-auto px-4 pb-2 scrollbar-hide">
            {popular.map((product) => (
              <ProductTile
                key={product.id}
                product={product}
                onClick={() => onNavigateToProduct(product)}
                layout="horizontal"
              />
            ))}
          </div>
        </div>

        {/* Recommendation Banner */}
        <div className="px-4">
          <div className="p-4 rounded-2xl bg-gradient-to-br from-[#EFF6FF] to-[#F7F8FA]">
            <h3 className="text-body text-[#111827] mb-2">Personalized for Max</h3>
            <p className="text-sub text-[#6B7280] mb-3">
              Get food recommendations based on Max's profile
            </p>
            <button className="h-9 px-4 rounded-xl bg-[#2563EB] text-white text-sub hover:bg-[#1d4ed8] active:scale-95 transition-all">
              View recommendations
            </button>
          </div>
        </div>

        {/* Category Chips */}
        <div className="px-4">
          <div className="flex gap-2 overflow-x-auto pb-2 -mx-4 px-4 scrollbar-hide">
            {categories.map((category) => (
              <PillChip
                key={category}
                label={category}
                selected={selectedCategory === category.toLowerCase()}
                onClick={() => setSelectedCategory(category.toLowerCase())}
              />
            ))}
          </div>
        </div>

        {/* Full Product Grid */}
        <div className="px-4">
          <div className="grid grid-cols-2 gap-4">
            {mockProducts.map((product) => (
              <ProductTile
                key={product.id}
                product={product}
                onClick={() => onNavigateToProduct(product)}
                layout="grid"
              />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
