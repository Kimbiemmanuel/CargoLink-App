// Carrier repository interface
import 'package:cargolink_app/core/models.dart';

abstract class CarrierRepository {
  Future<Map<String, dynamic>> getProfile();

  Future<void> updateProfile({
    required String fullName,
    required String licenseNumber,
    String? currentLatitude,
    String? currentLongitude,
  });

  Future<Map<String, dynamic>> getVehicleInfo();

  Future<void> updateVehicleInfo({
    required String vehicleType,
    required double vehicleCapacityKg,
    required String registrationNo,
    required String vehicleMake,
    required String vehicleModel,
  });

  Future<List<Booking>> getAvailableBookings({int page = 1});

  Future<void> acceptBooking(String bookingId);

  Future<void> rejectBooking(String bookingId);

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  });

  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  });

  Future<Map<String, dynamic>> getEarnings({
    String? period, // 'week', 'month', 'all'
  });

  Future<void> setAvailabilityStatus(bool isAvailable);

  Future<void> rateShipper({
    required String bookingId,
    required double rating,
    required String comment,
  });
}
