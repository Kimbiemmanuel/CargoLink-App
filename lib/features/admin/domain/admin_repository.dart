// Admin repository interface
abstract class AdminRepository {
  Future<Map<String, dynamic>> getDashboardStats();

  Future<List<Map<String, dynamic>>> getAllUsers({
    String? userType,
    int page = 1,
  });

  Future<Map<String, dynamic>> getUserDetails(String userId);

  Future<void> verifyCarrier(String carrierId);

  Future<void> suspendUser({required String userId, required String reason});

  Future<void> unsuspendUser(String userId);

  Future<List<Map<String, dynamic>>> getDisputes({
    String? status,
    int page = 1,
  });

  Future<Map<String, dynamic>> getDisputeDetails(String disputeId);

  Future<void> resolveDispute({
    required String disputeId,
    required String resolution,
    required String notes,
  });

  Future<List<Map<String, dynamic>>> getReports({
    String? reportType,
    String? dateFrom,
    String? dateTo,
  });

  Future<Map<String, dynamic>> getSystemSettings();

  Future<void> updateSystemSettings({required Map<String, dynamic> settings});
}
