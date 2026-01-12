// Role selection widget with card-based selection
import 'package:flutter/material.dart';
import '../../../../config/app_theme.dart';
import '../../../../core/constants.dart';

class RoleSelectorWidget extends StatefulWidget {
  final Function(String) onRoleSelected;
  final String? initialRole;

  const RoleSelectorWidget({
    Key? key,
    required this.onRoleSelected,
    this.initialRole,
  }) : super(key: key);

  @override
  State<RoleSelectorWidget> createState() => _RoleSelectorWidgetState();
}

class _RoleSelectorWidgetState extends State<RoleSelectorWidget> {
  late String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Your Role',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            _buildRoleCard(
              role: Constants.roleShipper,
              title: 'Shipper',
              description: 'Send and track shipments',
              icon: Icons.local_shipping_outlined,
              color: const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 12),
            _buildRoleCard(
              role: Constants.roleCarrier,
              title: 'Carrier',
              description: 'Accept and deliver shipments',
              icon: Icons.directions_car_outlined,
              color: const Color(0xFF2196F3),
            ),
            const SizedBox(height: 12),
            _buildRoleCard(
              role: Constants.roleAdmin,
              title: 'Admin',
              description: 'Manage platform and users',
              icon: Icons.admin_panel_settings_outlined,
              color: const Color(0xFFFF9800),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required String role,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
        widget.onRoleSelected(role);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.lightGray,
            width: isSelected ? 2 : 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.08)
              : Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.lightGray,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}

// Simple role selection chips (alternative UI)
class RoleSelectionChips extends StatefulWidget {
  final Function(String) onRoleSelected;
  final String? initialRole;

  const RoleSelectionChips({
    Key? key,
    required this.onRoleSelected,
    this.initialRole,
  }) : super(key: key);

  @override
  State<RoleSelectionChips> createState() => _RoleSelectionChipsState();
}

class _RoleSelectionChipsState extends State<RoleSelectionChips> {
  late String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          [Constants.roleShipper, Constants.roleCarrier, Constants.roleAdmin]
              .map(
                (role) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRole = role;
                    });
                    widget.onRoleSelected(role);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _selectedRole == role
                          ? AppTheme.primaryColor
                          : Colors.white,
                      border: Border.all(
                        color: _selectedRole == role
                            ? AppTheme.primaryColor
                            : AppTheme.lightGray,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      role,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _selectedRole == role
                            ? Colors.white
                            : AppTheme.textColor,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
