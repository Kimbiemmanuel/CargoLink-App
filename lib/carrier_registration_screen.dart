import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CarrierRegistrationScreen extends StatefulWidget {
  const CarrierRegistrationScreen({super.key});

  @override
  State<CarrierRegistrationScreen> createState() => _CarrierRegistrationScreenState();
}

class _CarrierRegistrationScreenState extends State<CarrierRegistrationScreen> {
  String selectedTruckType = 'Flatbed';
  File? _licenseFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickLicense(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );

      if (pickedFile != null) {
        setState(() {
          _licenseFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F26),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blueAccent),
              title: const Text("Gallery", style: TextStyle(color: Colors.white)),
              onTap: () {
                _pickLicense(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
              title: const Text("Camera", style: TextStyle(color: Colors.white)),
              onTap: () {
                _pickLicense(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(title: const Text("Carrier Setup")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Vehicle Information",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Register your primary vehicle to start receiving loads.",
                style: TextStyle(color: Colors.white60)),

            const SizedBox(height: 30),

            // Truck Type Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedTruckType,
                  dropdownColor: const Color(0xFF1A1F26),
                  style: const TextStyle(color: Colors.white),
                  isExpanded: true,
                  items: <String>['Flatbed', 'Reefer', 'Box Truck', 'Van'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedTruckType = val!),
                ),
              ),
            ),

            const SizedBox(height: 20),
            _buildCarrierField("Vehicle Plate Number", "ABC-1234"),
            const SizedBox(height: 20),
            _buildCarrierField("Max Payload (kg)", "15000", keyboardType: TextInputType.number),

            const SizedBox(height: 40),

            // License Upload
            GestureDetector(
              onTap: _showPickerOptions,
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.5), style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blueAccent.withOpacity(0.05),
                ),
                child: _licenseFile == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file, color: Colors.blueAccent),
                          SizedBox(height: 8),
                          Text("Upload Commercial License", style: TextStyle(color: Colors.blueAccent, fontSize: 12)),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 30),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              _licenseFile!.path.split('/').last, // Show file name
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/carrier_dashboard', (route) => false);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                child: const Text("Complete Registration"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarrierField(String label, String hint, {TextInputType? keyboardType}) {
    return TextFormField(
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}
