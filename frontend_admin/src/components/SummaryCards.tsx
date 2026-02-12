import { FolderOpen, Clock, CheckCircle2, AlertCircle } from 'lucide-react';

const summaryData = [
  {
    icon: FolderOpen,
    title: 'Total Projects',
    value: '24',
    description: '4 new this month',
    color: 'blue',
  },
  {
    icon: Clock,
    title: 'In Progress',
    value: '8',
    description: '3 due this week',
    color: 'yellow',
  },
  {
    icon: CheckCircle2,
    title: 'Completed',
    value: '142',
    description: '12 this month',
    color: 'green',
  },
  {
    icon: AlertCircle,
    title: 'Pending Review',
    value: '6',
    description: '2 overdue',
    color: 'purple',
  },
];

const colorMap = {
  blue: 'bg-blue-100 text-blue-600',
  yellow: 'bg-yellow-100 text-yellow-600',
  green: 'bg-green-100 text-green-600',
  purple: 'bg-purple-100 text-purple-600',
};

export function SummaryCards() {
  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
      {summaryData.map((card) => (
        <div
          key={card.title}
          className="bg-white rounded-lg shadow-sm border border-gray-200 p-5 hover:shadow-md transition-shadow"
        >
          <div className="flex items-start justify-between mb-4">
            <div className={`w-12 h-12 rounded-lg flex items-center justify-center ${colorMap[card.color]}`}>
              <card.icon className="w-6 h-6" />
            </div>
          </div>
          <h3 className="text-sm text-gray-600 mb-1">{card.title}</h3>
          <p className="text-3xl font-semibold text-gray-900 mb-2">{card.value}</p>
          <p className="text-sm text-gray-500">{card.description}</p>
        </div>
      ))}
    </div>
  );
}
