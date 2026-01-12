// Shipper booking form widget
import 'package:flutter/material.dart';
import '../../../../config/app_theme.dart';
import '../../../../core/constants.dart';

class ShipperBookingForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onBookingSubmit;

  const ShipperBookingForm({Key? key, required this.onBookingSubmit})
    : super(key: key);

  @override
  State<ShipperBookingForm> createState() => _ShipperBookingFormState();
}

class _ShipperBookingFormState extends State<ShipperBookingForm> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedCargoType;
  final _pickupLocationController = TextEditingController();
  final _deliveryLocationController = TextEditingController();
  final _distanceController = TextEditingController();
  final _weightController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estimatedValueController = TextEditingController();

  bool _isFragile = false;
  bool _requiresSignature = false;

  @override
  void dispose() {
    _pickupLocationController.dispose();
    _deliveryLocationController.dispose();
    _distanceController.dispose();
    _weightController.dispose();
    _descriptionController.dispose();
    _estimatedValueController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final bookingData = {
        'cargoType': _selectedCargoType,
        'pickupLocation': _pickupLocationController.text,
        'deliveryLocation': _deliveryLocationController.text,
        'distance': double.parse(_distanceController.text),
        'weight': double.parse(_weightController.text),
        'description': _descriptionController.text,
        'estimatedValue': double.parse(_estimatedValueController.text),
        'isFragile': _isFragile,
        'requiresSignature': _requiresSignature,
      };

      widget.onBookingSubmit(bookingData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cargo Type Selection
            const Text(
              'Cargo Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCargoType,
              decoration: InputDecoration(
                hintText: 'Select cargo type',
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
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                prefixIcon: const Icon(Icons.local_shipping_outlined),
              ),
              items: Constants.cargoTypes
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCargoType = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a cargo type';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Pickup Location
            const Text(
              'Pickup Location',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _pickupLocationController,
              decoration: InputDecoration(
                hintText: 'Enter pickup address',
                prefixIcon: const Icon(Icons.location_on_outlined),
                prefixIconColor: AppTheme.primaryColor,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location_outlined),
                  onPressed: () {
                    // TODO: Implement location picker
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Location picker')),
                    );
                  },
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
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pickup location is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Delivery Location
            const Text(
              'Delivery Location',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _deliveryLocationController,
              decoration: InputDecoration(
                hintText: 'Enter delivery address',
                prefixIcon: const Icon(Icons.location_on_outlined),
                prefixIconColor: AppTheme.primaryColor,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location_outlined),
                  onPressed: () {
                    // TODO: Implement location picker
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Location picker')),
                    );
                  },
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
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Delivery location is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Distance Input
            const Text(
              'Estimated Distance (km)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _distanceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                suffixText: 'km',
                prefixIcon: const Icon(Icons.straighten_outlined),
                prefixIconColor: AppTheme.primaryColor,
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
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Distance is required';
                }
                final distance = double.tryParse(value);
                if (distance == null || distance <= 0) {
                  return 'Please enter a valid distance';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Weight Input
            const Text(
              'Weight (kg)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                suffixText: 'kg',
                prefixIcon: const Icon(Icons.scale_outlined),
                prefixIconColor: AppTheme.primaryColor,
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
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Weight is required';
                }
                final weight = double.tryParse(value);
                if (weight == null || weight <= 0) {
                  return 'Please enter a valid weight';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Describe your cargo (optional)',
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
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Estimated Value
            const Text(
              'Estimated Value',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _estimatedValueController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                prefixText: '\$ ',
                prefixIcon: const Icon(Icons.attach_money_outlined),
                prefixIconColor: AppTheme.primaryColor,
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
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Estimated value is required';
                }
                final value_amount = double.tryParse(value);
                if (value_amount == null || value_amount < 0) {
                  return 'Please enter a valid value';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Checkboxes
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.lightGray),
                borderRadius: BorderRadius.circular(12),
                color: AppTheme.backgroundColor,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('This cargo is fragile'),
                    subtitle: const Text('Handle with care'),
                    value: _isFragile,
                    onChanged: (value) {
                      setState(() {
                        _isFragile = value ?? false;
                      });
                    },
                    activeColor: AppTheme.primaryColor,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(height: 16),
                  CheckboxListTile(
                    title: const Text('Signature required'),
                    subtitle: const Text('Requires recipient signature'),
                    value: _requiresSignature,
                    onChanged: (value) {
                      setState(() {
                        _requiresSignature = value ?? false;
                      });
                    },
                    activeColor: AppTheme.primaryColor,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create Booking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
