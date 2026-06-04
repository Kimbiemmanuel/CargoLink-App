// Firebase is not used in this build — app connects to Django backend
// Kept as a stub to avoid import errors in any referencing files
class FirebaseConfig {
  static Future<void> initialize() async {
    // No-op: Firebase replaced by Django REST API
  }
}
