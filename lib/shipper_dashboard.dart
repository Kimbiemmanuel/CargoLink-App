import 'package:flutter/material.dart';

class ShipperDashboard extends StatelessWidget {
  const ShipperDashboard({super.key});

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
            const Text(
              "Hello, John!",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 5),
            const Text(
              "Track your goods",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            // Status Summary Cards
            Row(
              children: [
                _buildStatusCard("Active", "12", Colors.blueAccent, Icons.local_shipping),
                const SizedBox(width: 15),
                _buildStatusCard("Pending", "05", Colors.orangeAccent, Icons.access_time),
              ],
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

            // Shipment List
            _buildShipmentItem(context, "Electronics Batch A", "New York", "Chicago", "In Transit"),
            _buildShipmentItem(context, "Industrial Pipes", "Houston", "Dallas", "Pending"),
            _buildShipmentItem(context, "Office Furniture", "Atlanta", "Miami", "Delivered"),
          ],
        ),
      ),

      // Floating Action Button to create a shipment
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/post_load'); // Now links to the form
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
