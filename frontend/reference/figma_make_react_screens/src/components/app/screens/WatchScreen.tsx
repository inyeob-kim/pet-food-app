import { useState } from 'react';
import { AppBar } from '../components/AppBar';
import { PillChip } from '../components/PillChip';
import { ProductTile } from '../components/ProductTile';
import { EmptyState } from '../components/EmptyState';
import { mockProducts } from '../data/mockData';

type WatchScreenProps = {
  onNavigateToProduct: (product: any) => void;
  onNavigateToMarket: () => void;
};

export function WatchScreen({ onNavigateToProduct, onNavigateToMarket }: WatchScreenProps) {
  const [sortBy, setSortBy] = useState('recent');
  
  const watchedProducts = mockProducts.filter(p => p.isWatched);
  const isEmpty = watchedProducts.length === 0;

  if (isEmpty) {
    return (
      <div>
        <AppBar title="Watch" />
        <EmptyState
          emoji="❤️"
          title="No watched products yet"
          description="Start watching products to get price alerts and updates"
          ctaText="Browse products"
          onCTA={onNavigateToMarket}
        />
      </div>
    );
  }

  return (
    <div className="pb-6">
      <AppBar title="Watch" />
      
      <div className="px-4 space-y-6">
        {/* Summary Hero Number */}
        <div className="pt-6">
          <div className="text-hero text-[#2563EB] mb-2">{watchedProducts.length}</div>
          <p className="text-body text-[#6B7280]">Products you're watching</p>
        </div>

        {/* Sorting Pills */}
        <div className="flex gap-2 overflow-x-auto pb-2 -mx-4 px-4 scrollbar-hide">
          <PillChip 
            label="Recent" 
            selected={sortBy === 'recent'} 
            onClick={() => setSortBy('recent')}
          />
          <PillChip 
            label="Price drop" 
            selected={sortBy === 'price-drop'} 
            onClick={() => setSortBy('price-drop')}
          />
          <PillChip 
            label="Lowest price" 
            selected={sortBy === 'lowest'} 
            onClick={() => setSortBy('lowest')}
          />
          <PillChip 
            label="Highest rated" 
            selected={sortBy === 'rating'} 
            onClick={() => setSortBy('rating')}
          />
        </div>

        {/* Product Grid */}
        <div className="grid grid-cols-2 gap-4">
          {watchedProducts.map((product) => (
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
  );
}
