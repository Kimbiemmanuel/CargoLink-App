// Global constants
class Constants {
  // API endpoints
  static const String baseUrl = 'http://localhost:8000/api';
  static const String firebaseProjectId = 'cargolink-project';
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // User roles
  static const String roleShipper = 'Shipper';
  static const String roleCarrier = 'Carrier';
  static const String roleAdmin = 'Admin';
  
  // Booking statuses
  static const String statusPending = 'Pending';
  static const String statusAccepted = 'Accepted';
  static const String statusPickedUp = 'Picked_Up';
  static const String statusInTransit = 'In_Transit';
  static const String statusDelivered = 'Delivered';
  static const String statusCancelled = 'Cancelled';
  
  // Cargo types
  static const List<String> cargoTypes = [
    'Documents',
    'Electronics',
    'Furniture',
    'Food',
    'Others'
  ];
  
  // Vehicle types
  static const List<String> vehicleTypes = [
    'Bike',
    'Van',
    'Pickup',
    'Small_Truck',
    'Large_Truck'
  ];
  
  // Admin roles
  static const List<String> adminRoles = [
    'Super_Admin',
    'Moderator',
    'Support'
  ];
  
  // Rating scale
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  
  // Pagination
  static const int pageSize = 20;
}
