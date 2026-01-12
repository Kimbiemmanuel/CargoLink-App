// Core domain models
class User {
  final String id;
  final String email;
  final String phone;
  final String userType; // Shipper, Carrier, Admin
  final String? firstName;
  final String? lastName;
  final bool isEmailVerified;
  final double averageRating;
  final int totalRatings;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.phone,
    required this.userType,
    this.firstName,
    this.lastName,
    required this.isEmailVerified,
    required this.averageRating,
    required this.totalRatings,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      userType: map['user_type'] ?? '',
      firstName: map['first_name'],
      lastName: map['last_name'],
      isEmailVerified: map['is_email_verified'] ?? false,
      averageRating: (map['average_rating'] ?? 0).toDouble(),
      totalRatings: map['total_ratings'] ?? 0,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'user_type': userType,
      'first_name': firstName,
      'last_name': lastName,
      'is_email_verified': isEmailVerified,
      'average_rating': averageRating,
      'total_ratings': totalRatings,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Booking {
  final String id;
  final String shipperId;
  final String? carrierId;
  final String pickupLocation;
  final double pickupLatitude;
  final double pickupLongitude;
  final String dropoffLocation;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final String cargoType;
  final double cargoWeightKg;
  final String status;
  final double fareAmount;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.shipperId,
    this.carrierId,
    required this.pickupLocation,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffLocation,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.cargoType,
    required this.cargoWeightKg,
    required this.status,
    required this.fareAmount,
    required this.createdAt,
  });

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] ?? '',
      shipperId: map['shipper'] ?? '',
      carrierId: map['carrier'],
      pickupLocation: map['pickup_location'] ?? '',
      pickupLatitude: (map['pickup_latitude'] ?? 0).toDouble(),
      pickupLongitude: (map['pickup_longitude'] ?? 0).toDouble(),
      dropoffLocation: map['dropoff_location'] ?? '',
      dropoffLatitude: (map['dropoff_latitude'] ?? 0).toDouble(),
      dropoffLongitude: (map['dropoff_longitude'] ?? 0).toDouble(),
      cargoType: map['cargo_type'] ?? '',
      cargoWeightKg: (map['cargo_weight_kg'] ?? 0).toDouble(),
      status: map['status'] ?? 'Pending',
      fareAmount: (map['fare_amount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shipper': shipperId,
      'carrier': carrierId,
      'pickup_location': pickupLocation,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'dropoff_location': dropoffLocation,
      'dropoff_latitude': dropoffLatitude,
      'dropoff_longitude': dropoffLongitude,
      'cargo_type': cargoType,
      'cargo_weight_kg': cargoWeightKg,
      'status': status,
      'fare_amount': fareAmount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
