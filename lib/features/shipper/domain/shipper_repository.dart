// Shipper repository interface
import 'package:cargolink_app/core/models.dart';

abstract class ShipperRepository {
  Future<Map<String, dynamic>> getProfile();

  Future<void> updateProfile({
    required String fullName,
    required String address,
    required String city,
    required String state,
    String? country,
  });

  Future<Booking> createBooking({
    required String pickupLocation,
    required double pickupLatitude,
    required double pickupLongitude,
    required String dropoffLocation,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required String cargoType,
    required double cargoWeightKg,
    required double fareAmount,
  });

  Future<List<Booking>> getMyBookings({String? status, int page = 1});

  Future<Booking> getBookingDetails(String bookingId);

  Future<void> cancelBooking(String bookingId);

  Future<void> rateCarrier({
    required String bookingId,
    required double rating,
    required String comment,
  });
}
