// Authentication repository interface — backed by Django REST API
abstract class AuthRepository {
  Future<Map<String, dynamic>> signUp({
    required String username,
    required String email,
    required String password,
    required String phone,
  });

  Future<String> signIn({required String email, required String password});

  Future<void> signOut();

  Future<void> resetPassword({required String email});

  String? getCurrentToken();
}
