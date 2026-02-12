import { useState, useEffect } from 'react';
import { ProductList } from '../components/ingredients/ProductList';
import { ProductDetail } from '../components/ingredients/ProductDetail';
import { Product } from '../data/mockProducts';
import { productService } from '../services/productService';
import { toast } from 'sonner@2.0.3';
import { ApiError } from '../config/api';

export function IngredientsTab() {
  const [selectedProduct, setSelectedProduct] = useState<Product | null>(null);
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // 상품 목록 로드
  useEffect(() => {
    loadProducts();
  }, []);

  const loadProducts = async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await productService.getProducts({ includeInactive: true });
      setProducts(response.products || []);
    } catch (err) {
      const errorMessage = err instanceof ApiError 
        ? `API 오류: ${err.status} ${err.statusText}`
        : err instanceof Error 
        ? err.message 
        : '상품 목록을 불러오는데 실패했습니다.';
      setError(errorMessage);
      toast.error(errorMessage);
      console.error('상품 목록 로드 실패:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleProductSelect = async (product: Product) => {
    try {
      // 상세 정보 다시 로드
      const fullProduct = await productService.getProduct(product.id);
      setSelectedProduct(fullProduct);
    } catch (err) {
      toast.error('상품 상세 정보를 불러오는데 실패했습니다.');
      console.error('상품 상세 로드 실패:', err);
      // 실패해도 기본 정보는 표시
      setSelectedProduct(product);
    }
  };

  const handleProductCreate = async (productData: Omit<Product, 'id' | 'createdAt' | 'updatedAt'>) => {
    try {
      const newProduct = await productService.createProduct({
        brandName: productData.brand,
        productName: productData.name,
        species: productData.species,
        isActive: productData.status === 'ACTIVE',
      });
      setProducts(prev => [newProduct, ...prev]);
      setSelectedProduct(newProduct);
      toast.success('새 상품이 생성되었습니다.');
    } catch (err) {
      const errorMessage = err instanceof ApiError 
        ? `생성 실패: ${err.status} ${err.statusText}`
        : '상품 생성에 실패했습니다.';
      toast.error(errorMessage);
      console.error('상품 생성 실패:', err);
    }
  };

  const handleProductUpdate = async (updatedProduct: Product) => {
    try {
      const result = await productService.updateProduct({
        id: updatedProduct.id,
        brandName: updatedProduct.brand,
        productName: updatedProduct.name,
        species: updatedProduct.species,
        isActive: updatedProduct.status === 'ACTIVE',
      });
      setProducts(prev =>
        prev.map(p => (p.id === result.id ? result : p))
      );
      setSelectedProduct(result);
      toast.success('상품이 업데이트되었습니다.');
    } catch (err) {
      const errorMessage = err instanceof ApiError 
        ? `업데이트 실패: ${err.status} ${err.statusText}`
        : '상품 업데이트에 실패했습니다.';
      toast.error(errorMessage);
      console.error('상품 업데이트 실패:', err);
    }
  };

  const handleProductDelete = async (productId: string) => {
    try {
      await productService.archiveProduct(productId);
      setProducts(prev => prev.filter(p => p.id !== productId));
      setSelectedProduct(null);
      toast.success('상품이 비활성화되었습니다.');
    } catch (err) {
      const errorMessage = err instanceof ApiError 
        ? `삭제 실패: ${err.status} ${err.statusText}`
        : '상품 삭제에 실패했습니다.';
      toast.error(errorMessage);
      console.error('상품 삭제 실패:', err);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-gray-500">로딩 중...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="admin-card p-6">
        <div className="text-red-600 mb-4">{error}</div>
        <button
          onClick={loadProducts}
          className="admin-btn px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white"
        >
          다시 시도
        </button>
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
      {/* Left Panel: Product List */}
      <div className="lg:col-span-7">
        <ProductList
          products={products}
          selectedProduct={selectedProduct}
          onProductSelect={handleProductSelect}
          onProductCreate={handleProductCreate}
          onRefresh={loadProducts}
        />
      </div>

      {/* Right Panel: Product Detail */}
      <div className="lg:col-span-5">
        <ProductDetail
          product={selectedProduct}
          onUpdate={handleProductUpdate}
          onDelete={handleProductDelete}
        />
      </div>
    </div>
  );
}