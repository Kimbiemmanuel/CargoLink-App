// Shipper booking screen that uses the booking form
import 'package:flutter/material.dart';
import '../../../../config/app_theme.dart';
import '../widgets/booking_form.dart';

class CreateBookingScreen extends StatefulWidget {
  const CreateBookingScreen({Key? key}) : super(key: key);

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  void _handleBookingSubmit(Map<String, dynamic> bookingData) {
    // TODO: Submit booking to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Booking created: ${bookingData['cargoType']} from ${bookingData['pickupLocation']}',
        ),
      ),
    );

    // Navigate back
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Create Booking'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ShipperBookingForm(onBookingSubmit: _handleBookingSubmit),
        ),
      ),
    );
  }
}
