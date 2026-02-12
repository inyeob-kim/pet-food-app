import { Search, Plus, ChevronDown } from 'lucide-react';
import { useState } from 'react';

export function Navbar() {
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);

  return (
    <nav className="fixed top-0 left-0 right-0 bg-white border-b border-gray-200 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <div className="flex items-center gap-8">
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 bg-gradient-to-br from-blue-600 to-purple-600 rounded-lg flex items-center justify-center">
                <span className="text-white font-bold text-sm">D</span>
              </div>
              <span className="font-semibold text-gray-900">Dashboard</span>
            </div>

            {/* Navigation Links */}
            <div className="hidden md:flex items-center gap-6">
              <a href="#" className="text-sm text-gray-900 font-medium hover:text-blue-600 transition-colors">
                Overview
              </a>
              <a href="#" className="text-sm text-gray-600 hover:text-gray-900 transition-colors">
                Projects
              </a>
              <a href="#" className="text-sm text-gray-600 hover:text-gray-900 transition-colors">
                Analytics
              </a>
              <a href="#" className="text-sm text-gray-600 hover:text-gray-900 transition-colors">
                Team
              </a>
            </div>
          </div>

          {/* Right Side */}
          <div className="flex items-center gap-4">
            {/* Search Field */}
            <div className="hidden sm:flex items-center gap-2 bg-gray-100 rounded-lg px-3 py-2 w-64">
              <Search className="w-4 h-4 text-gray-400" />
              <input
                type="text"
                placeholder="Search..."
                className="bg-transparent border-none outline-none text-sm text-gray-900 placeholder-gray-500 w-full"
              />
            </div>

            {/* New Project Button */}
            <button className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors text-sm font-medium">
              <Plus className="w-4 h-4" />
              <span className="hidden sm:inline">New Project</span>
            </button>

            {/* Avatar Dropdown */}
            <div className="relative">
              <button
                onClick={() => setIsDropdownOpen(!isDropdownOpen)}
                className="flex items-center gap-2 hover:bg-gray-100 rounded-lg px-2 py-1 transition-colors"
              >
                <div className="w-8 h-8 bg-gradient-to-br from-green-400 to-blue-500 rounded-full flex items-center justify-center">
                  <span className="text-white text-sm font-medium">JD</span>
                </div>
                <ChevronDown className="w-4 h-4 text-gray-600" />
              </button>

              {isDropdownOpen && (
                <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 py-1">
                  <a href="#" className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                    Profile
                  </a>
                  <a href="#" className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                    Settings
                  </a>
                  <a href="#" className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                    Billing
                  </a>
                  <hr className="my-1 border-gray-200" />
                  <a href="#" className="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">
                    Sign Out
                  </a>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </nav>
  );
}
