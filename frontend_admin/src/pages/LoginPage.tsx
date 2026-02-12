import { useState } from 'react';
import { useNavigate } from 'react-router';
import { toast } from 'sonner@2.0.3';

export function LoginPage() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    // Simulate login
    setTimeout(() => {
      if (email && password) {
        toast.success('로그인 성공!');
        navigate('/admin');
      } else {
        setError('이메일과 비밀번호를 입력해주세요.');
      }
      setLoading(false);
    }, 800);
  };

  return (
    <div className="min-h-screen flex items-center justify-center px-4">
      <div className="w-full max-w-md">
        <div className="admin-card p-8">
          {/* Logo & Title */}
          <div className="text-center mb-8">
            <div className="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-blue-500 to-cyan-400 rounded-2xl mb-4">
              <span className="text-white text-2xl font-bold">HZ</span>
            </div>
            <h1 className="text-2xl font-bold text-gray-900 mb-2">HeyGeno Admin</h1>
            <p className="text-sm text-gray-500">Ingredient & Campaign Console</p>
          </div>

          {/* Error Alert */}
          {error && (
            <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl text-sm text-red-700">
              {error}
            </div>
          )}

          {/* Login Form */}
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                이메일
              </label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="admin@heygeno.com"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                비밀번호
              </label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="••••••••"
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="admin-btn w-full bg-blue-500 hover:bg-blue-600 text-white py-3 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? '로그인 중...' : '로그인'}
            </button>
          </form>

          {/* Footer Note */}
          <p className="text-xs text-center text-gray-500 mt-6">
            관리자 전용 시스템입니다. 권한이 없는 경우 접근할 수 없습니다.
          </p>
        </div>
      </div>
    </div>
  );
}