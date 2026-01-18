import 'package:cargolink_application/trip_history_screen.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'app_settings_screen.dart';
import 'carrier_dashboard_screen.dart';
import 'fleet_management_screen.dart';
import 'privacy_security_screen.dart';
import 'support_screen.dart';
import 'carrier_registration_screen.dart';
import 'company_info_screen.dart';
import 'edit_profile_screen.dart';
import 'shipper_login.dart';
import 'shipper_registration.dart';
import 'shipper_dashboard.dart';
import 'post_load_screen.dart';
import 'tracking_map_screen.dart';
import 'shipper_profile_screen.dart';
import 'carrier_biding_screen.dart';
import 'payment_screen.dart';
import 'notification_settings_screen.dart';
import 'notification_screen.dart';
import 'active_trip_screen.dart';
import 'carrier_wallet_screen.dart';
import 'load_board_screen.dart';
import 'load_details_screen.dart';
import 'landing_page.dart';
import 'carrier_profile_screen.dart';

void main() {
  runApp(const CargoLinkApp());
}

class CargoLinkApp extends StatelessWidget {
  const CargoLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CargoLink',
      debugShowCheckedModeBanner: false,

      // Defining the Global App Theme
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Inter', // Note: Ensure you add a font to pubspec or it defaults to Roboto
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),

      // Route management
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/landing': (context) => const CargoLinkLandingPage(),
        '/shipper_login': (context) => const ShipperLoginScreen(),
        '/shipper_register': (context) => const ShipperRegistrationScreen(),
        '/shipper_dashboard': (context) => const ShipperDashboard(),
        '/post_load': (context) => const PostLoadScreen(),
        '/tracking': (context) => const TrackingMapScreen(),
        '/shipper_profile': (context) => const ShipperProfileScreen(),
        '/carrier_profile': (context) => const CarrierProfileScreen(),
        '/bidding_list': (context) => const CarrierBiddingScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/notification_settings': (context) => const NotificationSettingsScreen(),
        '/company_info': (context) => const CompanyInfoScreen(),
        '/privacy_security': (context) => const PrivacySecurityScreen(),
        '/support': (context) => const SupportScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/carrier_registration': (context) => const CarrierRegistrationScreen(),
        '/carrier_dashboard': (context) => const CarrierDashboardScreen(),
        '/load_board': (context) => const LoadBoardScreen(),
        '/load_details': (context) => const LoadDetailsScreen(),
        '/carrier_wallet': (context) => const CarrierWalletScreen(),
        '/active_trip': (context) => const ActiveTripScreen(),
        '/fleet': (context) => const FleetManagementScreen(),
        '/settings': (context) => const AppSettingsScreen(),
        '/history': (context) => const TripHistoryScreen(),
      },
    );
  }
}
