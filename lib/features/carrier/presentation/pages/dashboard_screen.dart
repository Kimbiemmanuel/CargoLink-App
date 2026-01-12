// Carrier dashboard screen showing nearby delivery requests
import 'package:flutter/material.dart';
import '../../../../config/app_routes.dart';
import '../../../../config/app_theme.dart';
import '../widgets/nearby_requests_card.dart';

class CarrierDashboardScreen extends StatefulWidget {
  const CarrierDashboardScreen({Key? key}) : super(key: key);

  @override
  State<CarrierDashboardScreen> createState() => _CarrierDashboardScreenState();
}

class _CarrierDashboardScreenState extends State<CarrierDashboardScreen> {
  String _selectedFilter = 'Nearby';
  final List<String> _filterOptions = ['Nearby', 'All', 'Saved'];

  // Mock data for nearby requests
  final List<Map<String, dynamic>> _nearbyRequests = [
    {
      'bookingId': 'BK001234',
      'pickupLocation': '123 Main St, Downtown',
      'deliveryLocation': '456 Oak Ave, Midtown',
      'cargoType': 'Documents',
      'distance': 5.2,
      'estimatedPay': 25.50,
      'minutesAgo': 3,
    },
    {
      'bookingId': 'BK001235',
      'pickupLocation': '789 Pine Rd, Uptown',
      'deliveryLocation': '321 Elm St, Downtown',
      'cargoType': 'Electronics',
      'distance': 8.7,
      'estimatedPay': 42.00,
      'minutesAgo': 5,
    },
    {
      'bookingId': 'BK001236',
      'pickupLocation': '555 Cedar Ln, West Side',
      'deliveryLocation': '999 Birch Blvd, East Side',
      'cargoType': 'Furniture',
      'distance': 12.5,
      'estimatedPay': 65.75,
      'minutesAgo': 8,
    },
    {
      'bookingId': 'BK001237',
      'pickupLocation': '222 Maple Dr, North End',
      'deliveryLocation': '888 Spruce Way, South End',
      'cargoType': 'Food',
      'distance': 3.1,
      'estimatedPay': 15.00,
      'minutesAgo': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Available Deliveries'),
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
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with earnings summary
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today\'s Earnings',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$245.50',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildEarningsStatItem('Completed', '8'),
                        _buildEarningsStatItem('In Progress', '2'),
                        _buildEarningsStatItem('Rating', '4.8★'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Filter chips
              const Text(
                'Filter Requests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filterOptions
                      .map(
                        (filter) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedFilter == filter
                                    ? AppTheme.primaryColor
                                    : Colors.white,
                                border: Border.all(
                                  color: _selectedFilter == filter
                                      ? AppTheme.primaryColor
                                      : AppTheme.lightGray,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _selectedFilter == filter
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

              // Nearby requests list
              Text(
                '${_nearbyRequests.length} Requests Found',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: List.generate(_nearbyRequests.length, (index) {
                  final request = _nearbyRequests[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: NearbyRequestCard(
                      bookingId: request['bookingId'],
                      pickupLocation: request['pickupLocation'],
                      deliveryLocation: request['deliveryLocation'],
                      cargoType: request['cargoType'],
                      distance: request['distance'],
                      estimatedPay: request['estimatedPay'],
                      minutesAgo: request['minutesAgo'],
                      onViewDetails: () {
                        // TODO: Navigate to booking details
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'View details for ${request['bookingId']}',
                            ),
                          ),
                        );
                      },
                      onAccept: () {
                        // TODO: Accept booking
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Accepted ${request['bookingId']}'),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.vehicleManagement);
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.directions_car),
      ),
    );
  }

  Widget _buildEarningsStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
