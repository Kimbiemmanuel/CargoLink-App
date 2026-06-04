import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/app_routes.dart';
import '../../../../config/app_theme.dart';
import '../../../../core/api_client.dart';
import '../../../../core/auth_provider.dart';

class ShipperDashboardScreen extends ConsumerStatefulWidget {
  const ShipperDashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ShipperDashboardScreen> createState() =>
      _ShipperDashboardScreenState();
}

class _ShipperDashboardScreenState
    extends ConsumerState<ShipperDashboardScreen> {
  List<dynamic> _bookings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final bookings = await ApiClient().getBookings();
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = null; // silently use empty list
        _bookings = [];
      });
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.pending;
      case 'accepted':
        return AppColors.accepted;
      case 'in_transit':
        return AppColors.inTransit;
      case 'delivered':
        return AppColors.delivered;
      case 'cancelled':
        return AppColors.cancelled;
      default:
        return AppColors.textSecondary;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'in_transit':
        return 'In Transit';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Shipments'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadBookings,
        child: CustomScrollView(
          slivers: [
            // ── Summary Header ────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.75),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${auth.email?.split('@').first ?? 'Shipper'} 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Track and manage your shipments',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statChip(
                          'Total',
                          '${_bookings.length}',
                          Icons.inventory_2_outlined,
                        ),
                        _statChip(
                          'Pending',
                          '${_bookings.where((b) => (b['status'] ?? '').toString().toLowerCase() == 'pending').length}',
                          Icons.hourglass_empty,
                        ),
                        _statChip(
                          'Delivered',
                          '${_bookings.where((b) => (b['status'] ?? '').toString().toLowerCase() == 'delivered').length}',
                          Icons.check_circle_outline,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Section title ─────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Your Bookings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // ── Booking List ──────────────────────────────────
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_bookings.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 72,
                        color: AppColors.textSecondary.withOpacity(0.4),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No bookings yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap the + button to create your first shipment',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _BookingCard(booking: _bookings[index]),
                    childCount: _bookings.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.of(context).pushNamed(
            AppRoutes.createBooking,
          );
          if (created == true) _loadBookings();
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Booking',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _statChip(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

// ── Booking Card ─────────────────────────────────────────────────────────────
class _BookingCard extends StatelessWidget {
  final dynamic booking;
  const _BookingCard({required this.booking});

  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'pending':
        return AppColors.pending;
      case 'accepted':
        return AppColors.accepted;
      case 'in_transit':
        return AppColors.inTransit;
      case 'delivered':
        return AppColors.delivered;
      case 'cancelled':
        return AppColors.cancelled;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = (booking['status'] ?? 'pending').toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BK${booking['id']?.toString().padLeft(6, '0') ?? '------'}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _locationRow(
            Icons.radio_button_checked,
            AppColors.primary,
            booking['pickup_location'] ?? booking['pickupLocation'] ?? '—',
          ),
          _arrowRow(),
          _locationRow(
            Icons.location_on,
            AppColors.error,
            booking['delivery_location'] ?? booking['deliveryLocation'] ?? '—',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _pill(
                Icons.category_outlined,
                booking['cargo_type'] ?? booking['cargoType'] ?? '—',
              ),
              const SizedBox(width: 8),
              if (booking['weight'] != null)
                _pill(
                  Icons.scale_outlined,
                  '${booking['weight']} kg',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _arrowRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 7, top: 2, bottom: 2),
      child: Container(
        height: 16,
        width: 2,
        color: AppColors.divider,
      ),
    );
  }

  Widget _pill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
