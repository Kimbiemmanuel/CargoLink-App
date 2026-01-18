import 'package:flutter/material.dart';

class TrackingMapScreen extends StatelessWidget {
  const TrackingMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CircleAvatar(
          backgroundColor: Colors.black26,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // MAP PLACEHOLDER
          // In a real app, you would use google_maps_flutter here.
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF1E293B), // Simulated Map Dark Mode
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map_outlined, color: Colors.white24, size: 100),
                  const SizedBox(height: 10),
                  Text(
                    "Map Interface Loading...",
                    style: TextStyle(color: Colors.white.withOpacity(0.3)),
                  ),
                ],
              ),
            ),
          ),

          // Draggable Status Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.15,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1F26),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Driver Info
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=driver'),
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Robert Fox", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                Text("Volvo FH16 • ABC-1234", style: TextStyle(color: Colors.white54, fontSize: 14)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                            child: const Icon(Icons.phone, color: Colors.white, size: 20),
                          ),
                        ],
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(color: Colors.white10),
                      ),

                      // Status & Timeline
                      _buildTrackingStep("Current Location", "I-95 North, Virginia", true, true),
                      _buildTrackingStep("Destination", "Warehouse 7, Jersey City", false, false),

                      const SizedBox(height: 25),

                      // Progress Bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Estimated Arrival", style: TextStyle(color: Colors.white54)),
                              Text("2h 45m", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: 0.65,
                            backgroundColor: Colors.white10,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                            borderRadius: BorderRadius.circular(10),
                            minHeight: 8,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStep(String title, String subtitle, bool isCompleted, bool showLine) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.blueAccent : Colors.white24,
              size: 20,
            ),
            if (showLine)
              Container(width: 2, height: 40, color: Colors.blueAccent.withOpacity(0.3)),
          ],
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(subtitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)),
          ],
        ),
      ],
    );
  }
}