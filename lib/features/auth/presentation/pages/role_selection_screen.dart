// Role selection screen - standalone page for role selection after login/signup
import 'package:flutter/material.dart';
import '../../../../config/app_routes.dart';
import '../../../../config/app_theme.dart';
import '../../../../core/constants.dart';
import '../widgets/role_selector_widget.dart';
import '../widgets/custom_button.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;
  bool _isLoading = false;

  void _handleRoleSelection() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role to continue')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate role selection process
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navigate based on selected role
      String route;
      switch (_selectedRole) {
        case Constants.roleShipper:
          route = AppRoutes.shipperDashboard;
          break;
        case Constants.roleCarrier:
          route = AppRoutes.carrierDashboard;
          break;
        case Constants.roleAdmin:
          route = AppRoutes.adminDashboard;
          break;
        default:
          route = AppRoutes.shipperDashboard;
      }

      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'How would you like to use CargoLink?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose your role to get started',
                style: TextStyle(fontSize: 16, color: AppTheme.lightGray),
              ),
              const SizedBox(height: 40),
              RoleSelectorWidget(
                initialRole: _selectedRole,
                onRoleSelected: (role) {
                  setState(() {
                    _selectedRole = role;
                  });
                },
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'Continue',
                onPressed: _handleRoleSelection,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Center(
                  child: Text(
                    'Back to Login',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
