// Payments repository interface
abstract class PaymentsRepository {
  Future<Map<String, dynamic>> initiatePayment({
    required String bookingId,
    required double amount,
  });

  Future<Map<String, dynamic>> verifyPayment({
    required String paymentIntentId,
  });

  Future<List<Map<String, dynamic>>> getTransactionHistory({int page = 1});

  Future<Map<String, dynamic>> getTransactionDetails(String transactionId);

  Future<void> refund({required String transactionId, String? reason});
}
