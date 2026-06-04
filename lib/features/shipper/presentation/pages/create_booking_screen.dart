import 'package:flutter/material.dart';
import '../../../../config/app_theme.dart';
import '../../../../core/api_client.dart';
import '../widgets/booking_form.dart';

class CreateBookingScreen extends StatefulWidget {
  const CreateBookingScreen({Key? key}) : super(key: key);

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  bool _isSubmitting = false;

  Future<void> _handleBookingSubmit(Map<String, dynamic> data) async {
    setState(() => _isSubmitting = true);
    try {
      // Map form fields to API fields
      final payload = {
        'pickup_location': data['pickupLocation'],
        'delivery_location': data['deliveryLocation'],
        'cargo_type': data['cargoType'],
        'weight': data['weight'],
        'distance': data['distance'],
        'description': data['description'] ?? '',
        'estimated_value': data['estimatedValue'],
        'is_fragile': data['isFragile'],
        'requires_signature': data['requiresSignature'],
      };
      await ApiClient().createBooking(payload);
      if (!mounted) return;
      // Show success screen
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const _BookingSuccessDialog(),
      );
      if (mounted) Navigator.of(context).pop(true); // return true = refresh list
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('401')
                ? 'Session expired. Please log in again.'
                : 'Failed to create booking. Check your connection.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('New Booking'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isSubmitting
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Creating your booking...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ShipperBookingForm(onBookingSubmit: _handleBookingSubmit),
              ),
            ),
    );
  }
}

// ── Success Dialog ────────────────────────────────────────────────────────────
class _BookingSuccessDialog extends StatelessWidget {
  const _BookingSuccessDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(32),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: AppColors.success,
              size: 48,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Booking Created!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your shipment request has been submitted. Carriers in your area will be notified.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Back to Dashboard',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
