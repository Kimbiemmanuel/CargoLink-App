import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // Dev: 10.0.2.2 = Android emulator alias for PC localhost
  // Prod: replace with your VPS IP e.g. 'http://178.62.10.25/api'
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio _dio;

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    // Attach token to every request automatically
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Token $token';
        }
        handler.next(options);
      },
      onError: (DioException e, handler) {
        handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;

  // Auth
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post('/login/', data: {
      'username': email,
      'password': password,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    final response = await _dio.post('/register/', data: {
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
    });
    return response.data;
  }

  // Bookings
  Future<List<dynamic>> getBookings() async {
    final response = await _dio.get('/bookings/');
    return response.data['results'] ?? response.data;
  }

  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) async {
    final response = await _dio.post('/bookings/', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> acceptBooking(int bookingId) async {
    final response = await _dio.post('/bookings/$bookingId/accept/');
    return response.data;
  }

  Future<Map<String, dynamic>> updateBookingStatus(
      int bookingId, String status) async {
    final response = await _dio.post('/bookings/$bookingId/update_status/',
        data: {'status': status});
    return response.data;
  }

  // Transactions
  Future<List<dynamic>> getTransactions() async {
    final response = await _dio.get('/transactions/');
    return response.data['results'] ?? response.data;
  }

  // Ratings
  Future<Map<String, dynamic>> submitRating({
    required int bookingId,
    required int toUserId,
    required int score,
    String? reviewText,
  }) async {
    final response = await _dio.post('/ratings/', data: {
      'booking': bookingId,
      'to_user': toUserId,
      'score': score,
      if (reviewText != null) 'review_text': reviewText,
    });
    return response.data;
  }
}
