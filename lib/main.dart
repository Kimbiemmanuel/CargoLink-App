import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';
import 'core/auth_provider.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/signup_screen.dart';
import 'features/auth/presentation/pages/role_selection_screen.dart';
import 'features/shipper/presentation/pages/create_booking_screen.dart';
import 'features/carrier/presentation/pages/dashboard_screen.dart';
import 'features/admin/presentation/pages/dashboard_screen.dart';

void main() {
  runApp(const ProviderScope(child: CargoLinkApp()));
}

class CargoLinkApp extends ConsumerWidget {
  const CargoLinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return MaterialApp(
      title: 'CargoLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Start at login or role selection depending on saved session
      initialRoute: auth.isLoggedIn ? AppRoutes.roleSelection : AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const SignupScreen(),
        AppRoutes.roleSelection: (_) => const RoleSelectionScreen(),
        AppRoutes.shipperDashboard: (_) => const CreateBookingScreen(),
        AppRoutes.carrierDashboard: (_) => const CarrierDashboardScreen(),
        AppRoutes.adminDashboard: (_) => const AdminDashboardScreen(),
      },
    );
  }
}
