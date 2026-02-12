import { MoreVertical, ArrowUpDown } from 'lucide-react';
import { useState } from 'react';

const tableData = [
  {
    id: 1,
    project: 'Website Redesign',
    client: 'Acme Corp',
    status: 'In Progress',
    priority: 'High',
    dueDate: '2026-02-20',
    progress: 75,
  },
  {
    id: 2,
    project: 'Mobile App Development',
    client: 'TechStart Inc',
    status: 'In Progress',
    priority: 'Medium',
    dueDate: '2026-03-15',
    progress: 45,
  },
  {
    id: 3,
    project: 'Brand Identity',
    client: 'Creative Studios',
    status: 'Completed',
    priority: 'Low',
    dueDate: '2026-02-10',
    progress: 100,
  },
  {
    id: 4,
    project: 'E-commerce Platform',
    client: 'RetailPro',
    status: 'In Progress',
    priority: 'High',
    dueDate: '2026-02-28',
    progress: 60,
  },
  {
    id: 5,
    project: 'Marketing Campaign',
    client: 'GrowthLabs',
    status: 'Review',
    priority: 'Medium',
    dueDate: '2026-02-18',
    progress: 90,
  },
  {
    id: 6,
    project: 'API Integration',
    client: 'DataSync',
    status: 'In Progress',
    priority: 'High',
    dueDate: '2026-02-25',
    progress: 30,
  },
  {
    id: 7,
    project: 'Dashboard Analytics',
    client: 'Metrics Co',
    status: 'Completed',
    priority: 'Medium',
    dueDate: '2026-02-05',
    progress: 100,
  },
  {
    id: 8,
    project: 'Content Management',
    client: 'PublishHub',
    status: 'Review',
    priority: 'Low',
    dueDate: '2026-03-01',
    progress: 85,
  },
];

const statusColors = {
  'In Progress': 'bg-blue-100 text-blue-700',
  'Completed': 'bg-green-100 text-green-700',
  'Review': 'bg-yellow-100 text-yellow-700',
};

const priorityColors = {
  'High': 'text-red-600',
  'Medium': 'text-yellow-600',
  'Low': 'text-gray-600',
};

export function EntriesTable() {
  const [sortColumn, setSortColumn] = useState<string | null>(null);
  const [sortDirection, setSortDirection] = useState<'asc' | 'desc'>('asc');

  const handleSort = (column: string) => {
    if (sortColumn === column) {
      setSortDirection(sortDirection === 'asc' ? 'desc' : 'asc');
    } else {
      setSortColumn(column);
      setSortDirection('asc');
    }
  };

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200">
      {/* Header */}
      <div className="px-6 py-4 border-b border-gray-200">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-lg font-semibold text-gray-900">Recent Projects</h2>
            <p className="text-sm text-gray-600 mt-1">Manage and track all your projects</p>
          </div>
          <button className="text-sm text-blue-600 hover:text-blue-700 font-medium">
            View All
          </button>
        </div>
      </div>

      {/* Table */}
      <div className="overflow-x-auto">
        <table className="w-full">
          <thead className="bg-gray-50 border-b border-gray-200">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                <button
                  onClick={() => handleSort('project')}
                  className="flex items-center gap-1 hover:text-gray-700"
                >
                  Project
                  <ArrowUpDown className="w-3 h-3" />
                </button>
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Client
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Status
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Priority
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Due Date
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Progress
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {tableData.map((entry) => (
              <tr key={entry.id} className="hover:bg-gray-50 transition-colors">
                <td className="px-6 py-4 whitespace-nowrap">
                  <div className="text-sm font-medium text-gray-900">{entry.project}</div>
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  <div className="text-sm text-gray-600">{entry.client}</div>
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  <span
                    className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${
                      statusColors[entry.status]
                    }`}
                  >
                    {entry.status}
                  </span>
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  <div className={`text-sm font-medium ${priorityColors[entry.priority]}`}>
                    {entry.priority}
                  </div>
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  <div className="text-sm text-gray-600">{entry.dueDate}</div>
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  <div className="flex items-center gap-2">
                    <div className="flex-1 bg-gray-200 rounded-full h-2 max-w-[100px]">
                      <div
                        className="bg-blue-600 h-2 rounded-full transition-all"
                        style={{ width: `${entry.progress}%` }}
                      />
                    </div>
                    <span className="text-sm text-gray-600">{entry.progress}%</span>
                  </div>
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  <button className="text-gray-400 hover:text-gray-600">
                    <MoreVertical className="w-5 h-5" />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Footer */}
      <div className="px-6 py-4 border-t border-gray-200 flex items-center justify-between">
        <div className="text-sm text-gray-600">
          Showing <span className="font-medium">1-8</span> of <span className="font-medium">24</span> projects
        </div>
        <div className="flex items-center gap-2">
          <button className="px-3 py-1 text-sm text-gray-600 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50">
            Previous
          </button>
          <button className="px-3 py-1 text-sm text-white bg-blue-600 rounded-lg hover:bg-blue-700">
            Next
          </button>
        </div>
      </div>
    </div>
  );
}
