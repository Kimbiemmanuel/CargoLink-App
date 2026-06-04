import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

class AuthState {
  final bool isLoggedIn;
  final String? token;
  final String? userType;
  final String? email;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isLoggedIn = false,
    this.token,
    this.userType,
    this.email,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? token,
    String? userType,
    String? email,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      userType: userType ?? this.userType,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _loadSavedSession();
  }

  Future<void> _loadSavedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userType = prefs.getString('user_type');
      final email = prefs.getString('email');
      if (token != null) {
        state = AuthState(
            isLoggedIn: true, token: token, userType: userType, email: email);
      }
    } catch (e) {
      // Silently fail - app will just start at login
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await ApiClient().login(email, password);
      final token = result['token'] as String;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('email', email);
      state = state.copyWith(
          isLoggedIn: true, token: token, email: email, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Invalid email or password');
      return false;
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ApiClient().register(
          username: username, email: email, password: password, phone: phone);
      // Auto-login after register
      return await login(email, password);
    } catch (e) {
      String msg = 'Registration failed. Please try again.';
      if (e.toString().contains('email')) msg = 'Email already in use.';
      if (e.toString().contains('phone')) msg = 'Phone number already in use.';
      state = state.copyWith(isLoading: false, error: msg);
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
