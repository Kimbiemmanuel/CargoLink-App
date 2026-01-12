// Admin dashboard screen with analytics and user management
import 'package:flutter/material.dart';
import '../../../../config/app_routes.dart';
import '../../../../config/app_theme.dart';
import '../widgets/analytics_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _selectedTab = 'Overview';
  final List<String> _tabOptions = ['Overview', 'Users', 'Disputes', 'Reports'];

  // Mock analytics data
  final Map<String, dynamic> _analyticsData = {
    'totalUsers': '1,245',
    'activeShippers': '523',
    'activeCarriers': '387',
    'totalBookings': '8,456',
    'completedBookings': '7,891',
    'totalRevenue': '\$125,430',
    'disputesOpen': '12',
    'disputesResolved': '156',
  };

  // Mock user data
  final List<Map<String, String>> _users = [
    {
      'name': 'John Smith',
      'email': 'john.smith@example.com',
      'role': 'Shipper',
      'status': 'Active',
      'joinDate': 'Jan 15, 2025',
    },
    {
      'name': 'Sarah Johnson',
      'email': 'sarah.j@example.com',
      'role': 'Carrier',
      'status': 'Active',
      'joinDate': 'Feb 3, 2025',
    },
    {
      'name': 'Mike Williams',
      'email': 'mike.w@example.com',
      'role': 'Shipper',
      'status': 'Suspended',
      'joinDate': 'Dec 20, 2024',
    },
    {
      'name': 'Emily Brown',
      'email': 'emily.brown@example.com',
      'role': 'Carrier',
      'status': 'Active',
      'joinDate': 'Jan 25, 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.notifications);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.adminSettings);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting section
              Text(
                'Welcome, Admin',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Here\'s what\'s happening on your platform today',
                style: TextStyle(fontSize: 14, color: AppTheme.lightGray),
              ),
              const SizedBox(height: 24),

              // Tab navigation
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _tabOptions
                      .map(
                        (tab) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTab = tab;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedTab == tab
                                    ? AppTheme.primaryColor
                                    : Colors.white,
                                border: Border.all(
                                  color: _selectedTab == tab
                                      ? AppTheme.primaryColor
                                      : AppTheme.lightGray,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                tab,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _selectedTab == tab
                                      ? Colors.white
                                      : AppTheme.textColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Content based on selected tab
              if (_selectedTab == 'Overview') ...[
                // Analytics Overview
                const Text(
                  'Key Metrics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AnalyticsCard(
                      title: 'Total Users',
                      value: _analyticsData['totalUsers'],
                      subtitle: '156 new this month',
                      icon: Icons.people_outline,
                      backgroundColor: const Color(0xFF2196F3).withOpacity(0.2),
                      iconColor: const Color(0xFF2196F3),
                      changePercent: '12',
                      isPositiveChange: true,
                    ),
                    AnalyticsCard(
                      title: 'Active Shippers',
                      value: _analyticsData['activeShippers'],
                      subtitle: '+8 this week',
                      icon: Icons.local_shipping_outlined,
                      backgroundColor: const Color(0xFF4CAF50).withOpacity(0.2),
                      iconColor: const Color(0xFF4CAF50),
                      changePercent: '5',
                      isPositiveChange: true,
                    ),
                    AnalyticsCard(
                      title: 'Active Carriers',
                      value: _analyticsData['activeCarriers'],
                      subtitle: '+12 this week',
                      icon: Icons.directions_car_outlined,
                      backgroundColor: const Color(0xFFFF9800).withOpacity(0.2),
                      iconColor: const Color(0xFFFF9800),
                      changePercent: '8',
                      isPositiveChange: true,
                    ),
                    AnalyticsCard(
                      title: 'Total Revenue',
                      value: _analyticsData['totalRevenue'],
                      subtitle: '+18% vs last month',
                      icon: Icons.attach_money_outlined,
                      backgroundColor: const Color(0xFF9C27B0).withOpacity(0.2),
                      iconColor: const Color(0xFF9C27B0),
                      changePercent: '18',
                      isPositiveChange: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Booking Statistics
                const Text(
                  'Booking Statistics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.lightGray),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildStatRow(
                        'Total Bookings',
                        _analyticsData['totalBookings'],
                        'Since platform launch',
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: AppTheme.lightGray),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        'Completed Bookings',
                        _analyticsData['completedBookings'],
                        '93% success rate',
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: AppTheme.lightGray),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        'Open Disputes',
                        _analyticsData['disputesOpen'],
                        'Requires attention',
                      ),
                    ],
                  ),
                ),
              ] else if (_selectedTab == 'Users') ...[
                // User Management
                const Text(
                  'Active Users',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: List.generate(_users.length, (index) {
                    final user = _users[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: UserManagementCard(
                        name: user['name']!,
                        email: user['email']!,
                        role: user['role']!,
                        status: user['status']!,
                        joinDate: user['joinDate']!,
                        onTap: () {
                          // TODO: Navigate to user details
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('View ${user['name']} details'),
                            ),
                          );
                        },
                        onSuspend: () {
                          // TODO: Suspend user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${user['name']} account suspended',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ] else if (_selectedTab == 'Disputes') ...[
                // Disputes Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.lightGray),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.gavel_outlined,
                          color: AppTheme.errorColor,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${_analyticsData['disputesOpen']} Open Disputes',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_analyticsData['disputesResolved']} resolved this month',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.lightGray,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.adminDisputes);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                          ),
                          child: const Text(
                            'View All Disputes',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (_selectedTab == 'Reports') ...[
                // Reports Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.lightGray),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.assessment_outlined,
                          color: AppTheme.primaryColor,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'System Reports',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Generate and download system reports',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.lightGray,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.adminReports);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                          ),
                          child: const Text(
                            'View Reports',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: AppTheme.lightGray),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }
}
