// Tracking repository interface
abstract class TrackingRepository {
  Future<Map<String, dynamic>> getBookingLocation(String bookingId);

  Future<List<Map<String, dynamic>>> getLocationHistory(String bookingId);

  Future<Stream<Map<String, dynamic>>> subscribeToLiveTracking(String bookingId);

  Future<void> updateLocation({
    required String bookingId,
    required double latitude,
    required double longitude,
  });
}
