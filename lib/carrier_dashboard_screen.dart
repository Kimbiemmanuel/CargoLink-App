import 'package:flutter/material.dart';

class CarrierDashboardScreen extends StatelessWidget {
  const CarrierDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Carrier Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/carrier_profile');
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Performance Overview
            const Text("Operations Overview", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildStatCard("Active", "3", Icons.local_shipping, Colors.orangeAccent, 
                  onTap: () => Navigator.pushNamed(context, '/fleet'),
                ),
                const SizedBox(width: 12),
                _buildStatCard("Earnings", "\$4.2k", Icons.payments_outlined, Colors.greenAccent,
                  onTap: () => Navigator.pushNamed(context, '/carrier_wallet'),
                ),
                const SizedBox(width: 12),
                _buildStatCard("Rating", "4.9", Icons.star_border, Colors.blueAccent),
              ],
            ),

            const SizedBox(height: 30),

            // 2. Current Trip Section (Actionable)
            const Text("Live Trip", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Load #TRK-9902", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(20)),
                        child: const Text("In Transit", style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildRouteLine("Pickup: Warehouse A (VA)", "Drop-off: Port Terminal (NY)"),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/active_trip');
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                      child: const Text("Open GPS / Update Status"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 3. Quick Actions
            const Text("Quick Actions", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildActionTile(Icons.search, "Find New Loads", "Browse available marketplace freight", Colors.blueAccent,
              onTap: () => Navigator.pushNamed(context, '/load_board'),
            ),
            _buildActionTile(Icons.history, "Trip History", "View completed deliveries and pods", Colors.white24, 
              onTap: () => Navigator.pushNamed(context, '/history'),
            ),
            _buildActionTile(Icons.account_balance_wallet_outlined, "Payouts", "Manage bank accounts and invoices", Colors.white24, 
              onTap: () => Navigator.pushNamed(context, '/carrier_wallet'),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, {void Function()? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 10),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteLine(String start, String end) {
    return Row(
      children: [
        const Column(
          children: [
            Icon(Icons.circle, color: Colors.blueAccent, size: 12),
            SizedBox(height: 4),
            Icon(Icons.more_vert, color: Colors.white10, size: 24),
            SizedBox(height: 4),
            Icon(Icons.location_on, color: Colors.redAccent, size: 12),
          ],
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(start, style: const TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(height: 25),
            Text(end, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String title, String sub, Color iconColor, {required void Function() onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        onTap: onTap,
      ),
    );
  }
}
