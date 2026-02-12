import { TrendingUp, Users, Target, Award } from 'lucide-react';
import { AreaChart, Area, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

const chartData = [
  { name: 'Jan', value: 4000, target: 3800 },
  { name: 'Feb', value: 3000, target: 3200 },
  { name: 'Mar', value: 5000, target: 4500 },
  { name: 'Apr', value: 4500, target: 4200 },
  { name: 'May', value: 6000, target: 5500 },
  { name: 'Jun', value: 5500, target: 5200 },
];

const achievementStats = [
  {
    icon: TrendingUp,
    label: 'Revenue',
    value: '$54,239',
    change: '+12.5%',
    positive: true,
  },
  {
    icon: Users,
    label: 'Active Users',
    value: '2,847',
    change: '+8.2%',
    positive: true,
  },
  {
    icon: Target,
    label: 'Completion Rate',
    value: '94.3%',
    change: '+3.1%',
    positive: true,
  },
  {
    icon: Award,
    label: 'Success Score',
    value: '98/100',
    change: '+5 pts',
    positive: true,
  },
];

export function HeroPanel() {
  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-6">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-2xl font-semibold text-gray-900 mb-2">Welcome back, John!</h1>
        <p className="text-gray-600">Here's what's happening with your projects today.</p>
      </div>

      {/* Achievement Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        {achievementStats.map((stat) => (
          <div
            key={stat.label}
            className="bg-gradient-to-br from-gray-50 to-gray-100 rounded-lg p-4 border border-gray-200"
          >
            <div className="flex items-center justify-between mb-3">
              <div className="w-10 h-10 bg-white rounded-lg flex items-center justify-center shadow-sm">
                <stat.icon className="w-5 h-5 text-blue-600" />
              </div>
              <span
                className={`text-sm font-medium ${
                  stat.positive ? 'text-green-600' : 'text-red-600'
                }`}
              >
                {stat.change}
              </span>
            </div>
            <p className="text-sm text-gray-600 mb-1">{stat.label}</p>
            <p className="text-2xl font-semibold text-gray-900">{stat.value}</p>
          </div>
        ))}
      </div>

      {/* Data Visualizations */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Area Chart */}
        <div>
          <h3 className="text-sm font-medium text-gray-900 mb-4">Performance Overview</h3>
          <ResponsiveContainer width="100%" height={200}>
            <AreaChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="name" stroke="#9ca3af" fontSize={12} />
              <YAxis stroke="#9ca3af" fontSize={12} />
              <Tooltip
                contentStyle={{
                  backgroundColor: '#fff',
                  border: '1px solid #e5e7eb',
                  borderRadius: '8px',
                  fontSize: '12px',
                }}
              />
              <Area
                type="monotone"
                dataKey="value"
                stroke="#3b82f6"
                fill="#3b82f6"
                fillOpacity={0.2}
                strokeWidth={2}
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        {/* Bar Chart */}
        <div>
          <h3 className="text-sm font-medium text-gray-900 mb-4">Goal Progress</h3>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="name" stroke="#9ca3af" fontSize={12} />
              <YAxis stroke="#9ca3af" fontSize={12} />
              <Tooltip
                contentStyle={{
                  backgroundColor: '#fff',
                  border: '1px solid #e5e7eb',
                  borderRadius: '8px',
                  fontSize: '12px',
                }}
              />
              <Bar dataKey="value" fill="#3b82f6" radius={[8, 8, 0, 0]} />
              <Bar dataKey="target" fill="#e5e7eb" radius={[8, 8, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
}
