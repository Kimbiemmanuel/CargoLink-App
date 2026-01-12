// Authentication service interface
import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class AuthRepository {
  Future<auth.User?> signUp({
    required String email,
    required String password,
    required String userType,
    required String phone,
  });

  Future<auth.User?> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> resetPassword({required String email});

  Future<void> verifyEmail();

  auth.User? getCurrentUser();

  Stream<auth.User?> authStateChanges();
}
