import { Outlet, useNavigate, useLocation } from 'react-router';
import { Settings, HelpCircle, LogOut, ChevronDown } from 'lucide-react';
import { useState } from 'react';
import { toast } from 'sonner@2.0.3';

export function AdminLayout() {
  const navigate = useNavigate();
  const location = useLocation();
  const [showProfileMenu, setShowProfileMenu] = useState(false);

  const activeTab = location.pathname === '/admin' ? 'ingredients' : 'events';

  const handleLogout = () => {
    toast.success('로그아웃되었습니다.');
    navigate('/admin/login');
  };

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="fixed top-0 left-0 right-0 bg-white border-b border-gray-200 z-50">
        <div className="max-w-[1600px] mx-auto px-6">
          <div className="flex items-center justify-between h-16">
            {/* Left: Wordmark */}
            <div className="flex items-center gap-3">
              <div className="flex items-center justify-center w-10 h-10 bg-gradient-to-br from-blue-500 to-cyan-400 rounded-xl">
                <span className="text-white font-bold text-sm">HZ</span>
              </div>
              <div>
                <div className="font-bold text-gray-900">HeyGeno Admin</div>
                <div className="text-xs text-gray-500">Ingredient & Campaign Console</div>
              </div>
            </div>

            {/* Middle: Main Tabs */}
            <div className="flex items-center gap-2 bg-gray-100 p-1 rounded-xl">
              <button
                onClick={() => navigate('/admin')}
                className={`px-6 py-2 rounded-lg text-sm font-semibold transition-all ${
                  activeTab === 'ingredients'
                    ? 'bg-white text-gray-900 shadow-sm'
                    : 'text-gray-600 hover:text-gray-900'
                }`}
              >
                사료 성분 관리
              </button>
              <button
                onClick={() => navigate('/admin/events')}
                className={`px-6 py-2 rounded-lg text-sm font-semibold transition-all ${
                  activeTab === 'events'
                    ? 'bg-white text-gray-900 shadow-sm'
                    : 'text-gray-600 hover:text-gray-900'
                }`}
              >
                이벤트 관리
              </button>
            </div>

            {/* Right: Environment + Profile */}
            <div className="flex items-center gap-3">
              <span className="px-3 py-1 bg-green-100 text-green-700 text-xs font-bold rounded-full">
                PROD
              </span>
              
              <button className="p-2 hover:bg-gray-100 rounded-lg transition-colors">
                <Settings className="w-5 h-5 text-gray-600" />
              </button>
              
              <button className="p-2 hover:bg-gray-100 rounded-lg transition-colors">
                <HelpCircle className="w-5 h-5 text-gray-600" />
              </button>

              {/* Profile Dropdown */}
              <div className="relative">
                <button
                  onClick={() => setShowProfileMenu(!showProfileMenu)}
                  className="flex items-center gap-2 px-3 py-2 hover:bg-gray-100 rounded-lg transition-colors"
                >
                  <div className="w-8 h-8 bg-gradient-to-br from-purple-400 to-pink-400 rounded-full flex items-center justify-center">
                    <span className="text-white text-sm font-semibold">관리</span>
                  </div>
                  <ChevronDown className="w-4 h-4 text-gray-600" />
                </button>

                {showProfileMenu && (
                  <>
                    <div
                      className="fixed inset-0 z-10"
                      onClick={() => setShowProfileMenu(false)}
                    />
                    <div className="absolute right-0 mt-2 w-56 bg-white rounded-xl shadow-xl border border-gray-200 py-2 z-20">
                      <div className="px-4 py-3 border-b border-gray-200">
                        <div className="font-semibold text-gray-900">관리자</div>
                        <div className="text-sm text-gray-500">admin@heygeno.com</div>
                      </div>
                      <button
                        onClick={handleLogout}
                        className="w-full px-4 py-2 text-left text-sm text-red-600 hover:bg-red-50 flex items-center gap-2"
                      >
                        <LogOut className="w-4 h-4" />
                        로그아웃
                      </button>
                    </div>
                  </>
                )}
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Content */}
      <main className="pt-16">
        <div className="max-w-[1600px] mx-auto px-6 py-8">
          <Outlet />
        </div>
      </main>
    </div>
  );
}