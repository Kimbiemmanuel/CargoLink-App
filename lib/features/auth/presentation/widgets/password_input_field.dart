// Password input field widget with visibility toggle
import 'package:flutter/material.dart';
import '../../../../config/app_theme.dart';

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String labelText;
  final String hintText;
  final bool isConfirmPassword;

  const PasswordInputField({
    Key? key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.labelText = 'Password',
    this.hintText = 'Enter your password',
    this.isConfirmPassword = false,
  }) : super(key: key);

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  late FocusNode _focusNode;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {});
      },
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: _obscureText,
        onChanged: widget.onChanged,
        validator: widget.validator ?? _defaultValidator,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          labelStyle: TextStyle(
            color: _focusNode.hasFocus
                ? AppTheme.primaryColor
                : AppTheme.textColor,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: const TextStyle(color: AppTheme.lightGray),
          prefixIcon: const Icon(Icons.lock_outline),
          prefixIconColor: _focusNode.hasFocus
              ? AppTheme.primaryColor
              : AppTheme.lightGray,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppTheme.primaryColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.lightGray),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.lightGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
          ),
          filled: true,
          fillColor: _focusNode.hasFocus
              ? AppTheme.backgroundColor
              : Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return widget.isConfirmPassword
          ? 'Please confirm your password'
          : 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
