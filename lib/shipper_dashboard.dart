import 'package:cargolink_application/models/dashboard_stats.dart';
import 'package:cargolink_application/services/api_service.dart';
import 'package:flutter/material.dart';

class ShipperDashboard extends StatefulWidget {
  final String username;
  final String token; // The auth token is now required

  const ShipperDashboard({super.key, required this.username, required this.token});

  @override
  State<ShipperDashboard> createState() => _ShipperDashboardState();
}

class _ShipperDashboardState extends State<ShipperDashboard> {
  late Future<DashboardStats> _dashboardStats;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Fetch the stats when the widget is first created
    _dashboardStats = _apiService.getDashboardStats(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("CargoLink Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/shipper_profile');
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, ${widget.username}!",
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 5),
            const Text(
              "Track your goods",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            // FutureBuilder to display dashboard stats
            FutureBuilder<DashboardStats>(
              future: _dashboardStats,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)));
                } else if (snapshot.hasData) {
                  final stats = snapshot.data!;
                  return Row(
                    children: [
                      _buildStatusCard("Active", stats.activeLoads.toString(), Colors.blueAccent, Icons.local_shipping),
                      const SizedBox(width: 15),
                      _buildStatusCard("Completed", stats.completed.toString(), Colors.greenAccent, Icons.check_circle_outline),
                    ],
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
            const SizedBox(height: 30),

            // Recent Shipments Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Shipments",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("View All", style: TextStyle(color: Colors.blueAccent)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Shipment List (This can also be updated with real data later)
            _buildShipmentItem(context, "Electronics Batch A", "New York", "Chicago", "In Transit"),
            _buildShipmentItem(context, "Industrial Pipes", "Houston", "Dallas", "Pending"),
            _buildShipmentItem(context, "Office Furniture", "Atlanta", "Miami", "Delivered"),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/post_load');
        },
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add),
        label: const Text("New Shipment"),
      ),
    );
  }

  Widget _buildStatusCard(String title, String count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 15),
            Text(count, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.white54, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentItem(BuildContext context, String title, String from, String to, String status) {
    return GestureDetector(
      onTap: () {
        if (status == "In Transit") {
          Navigator.pushNamed(context, '/tracking');
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.inventory_2_outlined, color: Colors.blueAccent),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("$from → $to", style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: status == "In Transit" ? Colors.blueAccent.withOpacity(0.2) : Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: status == "In Transit" ? Colors.blueAccent : Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
