import 'package:flutter/material.dart';
import '../../../../config/app_theme.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero Banner ──────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.75),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.local_shipping_rounded,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CargoLink',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'On-Demand Cargo Transportation Platform',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── About the Project ────────────────────────────
            _sectionCard(
              context,
              icon: Icons.info_outline,
              title: 'About the Project',
              child: const Text(
                'CargoLink is a real-time, on-demand cargo transportation platform '
                'built on a Service-Oriented Architecture (SOA). It connects '
                'Shippers who need to transport goods with Carriers who have '
                'available vehicles, enabling seamless booking, tracking, and '
                'delivery management.\n\n'
                'The platform is containerized using Docker and orchestrated '
                'with Kubernetes, ensuring high availability, fault tolerance, '
                'and automatic self-healing in production.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),

            // ── Tech Stack ───────────────────────────────────
            _sectionCard(
              context,
              icon: Icons.layers_outlined,
              title: 'Technology Stack',
              child: Column(
                children: [
                  _techRow('Backend', 'Django REST Framework (Python)', Icons.dns_outlined),
                  _techRow('Frontend', 'Flutter (Dart)', Icons.phone_android_outlined),
                  _techRow('Database', 'PostgreSQL 16', Icons.storage_outlined),
                  _techRow('Cache', 'Redis 7', Icons.bolt_outlined),
                  _techRow('Containers', 'Docker & Docker Compose', Icons.inventory_2_outlined),
                  _techRow('Orchestration', 'Kubernetes (K3s)', Icons.hub_outlined),
                  _techRow('Proxy', 'Nginx (Reverse Proxy)', Icons.router_outlined),
                  _techRow('Auth', 'Token Authentication (DRF)', Icons.lock_outline),
                ],
              ),
            ),

            // ── Architecture ─────────────────────────────────
            _sectionCard(
              context,
              icon: Icons.account_tree_outlined,
              title: 'System Architecture',
              child: Column(
                children: [
                  _archRow('SOA', 'Loosely coupled microservices'),
                  _archRow('Kubernetes', '2 Django replicas for zero-downtime'),
                  _archRow('Chaos Engineering', 'Fault-tolerant & self-healing'),
                  _archRow('REST API', 'JSON over HTTP/HTTPS'),
                  _archRow('WebSockets', 'Real-time tracking via Django Channels'),
                ],
              ),
            ),

            // ── Team Members ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.group_outlined,
                          color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Meet the Team',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _teamCard(
                    name: 'Kimbi Emmanuel Samsimbom Yisah',
                    role: 'Full-Stack Developer & Project Lead',
                    github: 'github.com/Kimbiemmanuel',
                    initials: 'KE',
                    color: AppColors.primary,
                    responsibilities: [
                      'Flutter mobile app development',
                      'Django REST API backend',
                      'Docker & Kubernetes deployment',
                      'Database architecture & design',
                    ],
                  ),
                  const SizedBox(height: 12),
                  _teamCard(
                    name: 'Che Hermann Bright',
                    role: 'Backend Developer & DevOps',
                    github: 'github.com/Bright-ch23',
                    initials: 'CH',
                    color: const Color(0xFF4CAF50),
                    responsibilities: [
                      'System architecture design',
                      'SOA services implementation',
                      'Infrastructure & cloud setup',
                      'Documentation & testing',
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Footer ───────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: AppColors.primary.withOpacity(0.05),
              child: Column(
                children: [
                  const Icon(Icons.school_outlined,
                      color: AppColors.primary, size: 32),
                  const SizedBox(height: 8),
                  const Text(
                    'Final Year Project',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© 2026 CargoLink Team. All rights reserved.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(BuildContext context,
      {required IconData icon,
      required String title,
      required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _techRow(String tech, String detail, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            '$tech: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
          Expanded(
            child: Text(
              detail,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _archRow(String label, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label — ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: desc,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamCard({
    required String name,
    required String role,
    required String github,
    required String initials,
    required Color color,
    required List<String> responsibilities,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      github,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),
          ...responsibilities.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 14, color: color),
                  const SizedBox(width: 6),
                  Text(
                    r,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
