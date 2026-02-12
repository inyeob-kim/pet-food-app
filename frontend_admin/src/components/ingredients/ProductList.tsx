import { useState } from 'react';
import { Search, RefreshCw, Plus, ChevronDown } from 'lucide-react';
import { Product } from '../../data/mockProducts';
import { toast } from 'sonner@2.0.3';
import { CreateProductDialog } from './CreateProductDialog';

interface ProductListProps {
  products: Product[];
  selectedProduct: Product | null;
  onProductSelect: (product: Product) => void;
  onProductCreate: (product: Omit<Product, 'id' | 'createdAt' | 'updatedAt'>) => void;
  onRefresh?: () => void;
}

export function ProductList({ products, selectedProduct, onProductSelect, onProductCreate, onRefresh }: ProductListProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [speciesFilter, setSpeciesFilter] = useState<string>('ALL');
  const [statusFilter, setStatusFilter] = useState<string>('ALL');
  const [showCreateDialog, setShowCreateDialog] = useState(false);

  const filteredProducts = products.filter((product) => {
    const matchesSearch =
      searchQuery === '' ||
      product.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      product.brand.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesSpecies = speciesFilter === 'ALL' || product.species === speciesFilter;
    const matchesStatus = statusFilter === 'ALL' || product.status === statusFilter;
    return matchesSearch && matchesSpecies && matchesStatus;
  });

  const handleRefresh = () => {
    if (onRefresh) {
      onRefresh();
    } else {
      toast.success('상품 목록을 새로고침했습니다.');
    }
  };

  const handleCreate = (productData: Omit<Product, 'id' | 'createdAt' | 'updatedAt'>) => {
    onProductCreate(productData);
    setShowCreateDialog(false);
    toast.success('새 상품이 생성되었습니다.');
  };

  return (
    <>
    <div className="admin-card p-6">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-xl font-bold text-gray-900">상품 목록</h2>
        <div className="flex items-center gap-2">
          <button
            onClick={handleRefresh}
            className="admin-btn px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 flex items-center gap-2"
          >
            <RefreshCw className="w-4 h-4" />
            새로고침
          </button>
          <button
            onClick={() => setShowCreateDialog(true)}
            className="admin-btn px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white flex items-center gap-2"
          >
            <Plus className="w-4 h-4" />
            새 상품
          </button>
        </div>
      </div>

      {/* Filters */}
      <div className="space-y-3 mb-6">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <input
            type="text"
            placeholder="상품명 / 브랜드 / SKU 검색"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="admin-input w-full pl-10 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div className="flex items-center gap-2">
          <select
            value={speciesFilter}
            onChange={(e) => setSpeciesFilter(e.target.value)}
            className="admin-input text-sm flex-1 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="ALL">전체 종</option>
            <option value="DOG">강아지</option>
            <option value="CAT">고양이</option>
          </select>

          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            className="admin-input text-sm flex-1 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="ALL">전체 상태</option>
            <option value="ACTIVE">활성</option>
            <option value="ARCHIVED">비활성</option>
          </select>
        </div>
      </div>

      {/* Product Table */}
      <div className="border border-gray-200 rounded-xl overflow-hidden">
        <div className="overflow-x-auto max-h-[600px] overflow-y-auto">
          <table className="w-full">
            <thead className="bg-gray-50 sticky top-0 z-10">
              <tr>
                <th className="w-16 px-3 py-3 text-left text-xs font-semibold text-gray-600">이미지</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 min-w-[200px]">상품명</th>
                <th className="w-20 px-3 py-3 text-left text-xs font-semibold text-gray-600 whitespace-nowrap">종</th>
                <th className="w-20 px-3 py-3 text-left text-xs font-semibold text-gray-600 whitespace-nowrap">상태</th>
                <th className="w-24 px-3 py-3 text-left text-xs font-semibold text-gray-600 whitespace-nowrap">수정일</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {filteredProducts.map((product) => (
                <tr
                  key={product.id}
                  onClick={() => onProductSelect(product)}
                  className={`cursor-pointer transition-colors ${
                    selectedProduct?.id === product.id
                      ? 'bg-blue-50'
                      : 'hover:bg-gray-50'
                  }`}
                >
                  <td className="px-3 py-3">
                    <img
                      src={product.thumbnail}
                      alt={product.name}
                      className="w-12 h-12 rounded-lg object-cover"
                    />
                  </td>
                  <td className="px-4 py-3">
                    <div className="font-semibold text-gray-900 truncate" title={product.name}>
                      {product.name}
                    </div>
                    <div className="text-xs text-gray-500 truncate" title={product.brand}>
                      {product.brand}
                    </div>
                  </td>
                  <td className="px-3 py-3">
                    <span
                      className={`inline-block px-2 py-1 rounded-full text-xs font-semibold whitespace-nowrap ${
                        product.species === 'DOG'
                          ? 'bg-blue-100 text-blue-700'
                          : 'bg-purple-100 text-purple-700'
                      }`}
                    >
                      {product.species === 'DOG' ? '강아지' : '고양이'}
                    </span>
                  </td>
                  <td className="px-3 py-3">
                    <span
                      className={`inline-block px-2 py-1 rounded-full text-xs font-semibold whitespace-nowrap ${
                        product.status === 'ACTIVE'
                          ? 'bg-green-100 text-green-700'
                          : 'bg-gray-100 text-gray-700'
                      }`}
                    >
                      {product.status === 'ACTIVE' ? '활성' : '비활성'}
                    </span>
                  </td>
                  <td className="px-3 py-3 text-xs text-gray-600 whitespace-nowrap">
                    {new Date(product.updatedAt).toLocaleDateString('ko-KR', { 
                      year: '2-digit', 
                      month: '2-digit', 
                      day: '2-digit' 
                    })}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Pagination */}
      <div className="flex items-center justify-between mt-4 text-sm text-gray-600">
        <span>총 {filteredProducts.length}개 상품</span>
        <div className="flex items-center gap-2">
          <button className="px-3 py-1 border border-gray-300 rounded-lg hover:bg-gray-50">
            이전
          </button>
          <button className="px-3 py-1 bg-blue-500 text-white rounded-lg">1</button>
          <button className="px-3 py-1 border border-gray-300 rounded-lg hover:bg-gray-50">
            다음
          </button>
        </div>
      </div>
    </div>

    {/* Create Product Dialog */}
    {showCreateDialog && (
      <CreateProductDialog
        onClose={() => setShowCreateDialog(false)}
        onCreate={handleCreate}
      />
    )}
    </>
  );
}