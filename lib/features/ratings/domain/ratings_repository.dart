// Ratings repository interface
abstract class RatingsRepository {
  Future<void> submitRating({
    required String bookingId,
    required double rating,
    required String comment,
    required String ratedUserId,
  });

  Future<Map<String, dynamic>> getUserRatings(String userId);

  Future<List<Map<String, dynamic>>> getBookingRatings(String bookingId);
}
