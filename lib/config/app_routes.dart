// App routing configuration

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String roleSelection = '/role-selection';
  
  // Shipper routes
  static const String shipperDashboard = '/shipper/dashboard';
  static const String createBooking = '/shipper/create-booking';
  static const String shipperBookings = '/shipper/bookings';
  static const String shipperProfile = '/shipper/profile';
  static const String shipperPayments = '/shipper/payments';
  
  // Carrier routes
  static const String carrierDashboard = '/carrier/dashboard';
  static const String availableBookings = '/carrier/available-bookings';
  static const String myEarnings = '/carrier/earnings';
  static const String carrierProfile = '/carrier/profile';
  static const String vehicleManagement = '/carrier/vehicle';
  
  // Admin routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminDisputes = '/admin/disputes';
  static const String adminReports = '/admin/reports';
  static const String adminSettings = '/admin/settings';
  
  // Common routes
  static const String trackingMap = '/tracking';
  static const String ratingPage = '/rating';
  static const String notifications = '/notifications';
  static const String help = '/help';
}
