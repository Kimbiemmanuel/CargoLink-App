# Firebase Authentication & Firestore Setup Guide

This guide outlines the complete setup for Firebase authentication and Firestore database for the CargoLink application with three user roles: Shipper, Carrier, and Admin.

---

## Prerequisites

- Firebase Project created
- Flutter Firebase CLI installed (`flutterfire_cli`)
- Python Firebase Admin SDK installed
- Google Cloud Console access

---

## Part 1: Firebase Project Setup

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create Project" → Name it `cargolink-project`
3. Enable Google Analytics (optional)
4. Create project

### Step 2: Register Flutter App

1. In Firebase Console, click "Add app" → Select **Flutter**
2. Enter iOS Bundle ID: `com.cargolink.app`
3. Enter Android Package Name: `com.cargolink.app`
4. Download `GoogleService-Info.plist` (iOS)
5. Download `google-services.json` (Android)

### Step 3: Enable Authentication Methods

Navigate to **Authentication** → **Sign-in method**

Enable:
- ✅ Email/Password
- ✅ Phone Number
- ✅ Google Sign-In
- ✅ Anonymous (for guest tracking)

---

## Part 2: Security Rules

### Authentication Rules

In Firebase Console → **Authentication** → **Users**

Configure the following custom claims structure:

```javascript
{
  "userType": "Shipper|Carrier|Admin",
  "isVerified": true,
  "isActive": true
}
```

### Firestore Security Rules

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // User profile access
    match /users/{userId} {
      allow read: if request.auth.uid == userId || request.auth.token.userType == 'Admin';
      allow write: if request.auth.uid == userId;
      allow create: if request.auth != null;
    }
    
    // Public user profiles (limited fields)
    match /users/{userId}/public {
      allow read: if request.auth != null;
    }
    
    // Bookings
    match /bookings/{bookingId} {
      allow read: if request.auth.uid == resource.data.shipperId || 
                     request.auth.uid == resource.data.carrierId ||
                     request.auth.token.userType == 'Admin';
      allow create: if request.auth.token.userType == 'Shipper';
      allow update: if request.auth.uid == resource.data.shipperId ||
                       request.auth.uid == resource.data.carrierId;
    }
    
    // Location tracking (real-time)
    match /bookings/{bookingId}/locations/{locationId} {
      allow read: if request.auth.uid == get(/databases/$(database)/documents/bookings/$(bookingId)).data.shipperId ||
                     request.auth.uid == get(/databases/$(database)/documents/bookings/$(bookingId)).data.carrierId;
      allow write: if request.auth.token.userType == 'Carrier';
    }
    
    // Ratings
    match /ratings/{ratingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.ratedBy;
    }
    
    // Support tickets
    match /supportTickets/{ticketId} {
      allow read: if request.auth.uid == resource.data.userId ||
                     request.auth.token.userType == 'Admin';
      allow create: if request.auth != null;
      allow update: if request.auth.uid == resource.data.userId ||
                       request.auth.token.userType == 'Admin';
    }
    
    // Admin only collections
    match /admin/{document=**} {
      allow read, write: if request.auth.token.userType == 'Admin' &&
                            request.auth.token.adminRole == 'Super_Admin';
    }
  }
}
```

---

## Part 3: Firestore Data Structure

### Collections Overview

```
cargolink-project/
├── users/
│   ├── {userId}/
│   │   ├── email: string
│   │   ├── phone: string
│   │   ├── userType: enum (Shipper|Carrier|Admin)
│   │   ├── firstName: string
│   │   ├── lastName: string
│   │   ├── averageRating: number
│   │   ├── isEmailVerified: boolean
│   │   ├── isActive: boolean
│   │   ├── createdAt: timestamp
│   │   ├── updatedAt: timestamp
│   │   └── public/ (subcollection - visible to others)
│   │       ├── displayName: string
│   │       ├── averageRating: number
│   │       └── profilePicture: string
│
├── shippers/
│   ├── {userId}/
│   │   ├── fullName: string
│   │   ├── address: string
│   │   ├── city: string
│   │   ├── state: string
│   │   ├── country: string
│   │   ├── paymentMethods: array
│   │   └── createdAt: timestamp
│
├── carriers/
│   ├── {userId}/
│   │   ├── fullName: string
│   │   ├── licenseNumber: string
│   │   ├── isVerified: boolean
│   │   ├── isAvailable: boolean
│   │   ├── currentLocation: geopoint
│   │   ├── totalEarnings: number
│   │   ├── completedJobs: number
│   │   ├── bankDetails: object
│   │   └── vehicle/
│   │       ├── type: enum (Bike|Van|Pickup|Small_Truck|Large_Truck)
│   │       ├── capacity: number
│   │       ├── registrationNumber: string
│   │       ├── make: string
│   │       ├── model: string
│   │       └── documents: array
│
├── bookings/
│   ├── {bookingId}/
│   │   ├── shipperId: string
│   │   ├── carrierId: string (optional)
│   │   ├── pickupLocation: geopoint
│   │   ├── dropoffLocation: geopoint
│   │   ├── cargoType: enum
│   │   ├── cargoWeight: number
│   │   ├── status: enum (Pending|Accepted|Picked_Up|In_Transit|Delivered|Cancelled)
│   │   ├── fare: number
│   │   ├── createdAt: timestamp
│   │   ├── acceptedAt: timestamp
│   │   ├── deliveredAt: timestamp
│   │   └── locations/ (subcollection - real-time tracking)
│   │       ├── {locationId}/
│   │       │   ├── latitude: number
│   │       │   ├── longitude: number
│   │       │   ├── timestamp: timestamp
│   │       │   └── accuracy: number
│
├── payments/
│   ├── {transactionId}/
│   │   ├── bookingId: string
│   │   ├── amount: number
│   │   ├── status: enum (Pending|Processing|Completed|Failed|Refunded)
│   │   ├── method: enum (Card|Mobile_Money|Bank_Transfer)
│   │   ├── stripeIntentId: string
│   │   ├── createdAt: timestamp
│   │   └── processedAt: timestamp
│
├── ratings/
│   ├── {ratingId}/
│   │   ├── bookingId: string
│   │   ├── ratedBy: string
│   │   ├── ratedUser: string
│   │   ├── rating: number (1-5)
│   │   ├── comment: string
│   │   ├── ratingType: enum
│   │   └── createdAt: timestamp
│
├── disputes/
│   ├── {disputeId}/
│   │   ├── bookingId: string
│   │   ├── raisedBy: string
│   │   ├── type: enum (Quality|Delay|Missing_Items|Damaged_Goods|Other)
│   │   ├── description: string
│   │   ├── status: enum (Open|In_Review|Resolved|Closed)
│   │   ├── resolvedBy: string
│   │   ├── createdAt: timestamp
│   │   └── resolvedAt: timestamp
│
├── notifications/
│   ├── {userId}/
│   │   └── {notificationId}/
│   │       ├── title: string
│   │       ├── message: string
│   │       ├── type: enum
│   │       ├── data: object
│   │       ├── isRead: boolean
│   │       ├── readAt: timestamp
│   │       └── createdAt: timestamp
│
└── admin/
    ├── settings/
    │   ├── platformCommission: number
    │   ├── minRating: number
    │   ├── maintenanceMode: boolean
    │   └── updatedAt: timestamp
```

---

## Part 4: Flutter Firebase Integration

### Step 1: Install Dependencies

```bash
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add cloud_firestore
flutter pub add google_sign_in
flutter pub add firebase_messaging  # Push notifications
```

### Step 2: Configure Firebase for Each Platform

#### iOS Setup
```bash
flutterfire configure --ios
```

#### Android Setup
```bash
flutterfire configure --android
```

#### Web Setup
```bash
flutterfire configure --web
```

### Step 3: Initialize Firebase in main.dart

Already created in `lib/config/firebase_config.dart`

---

## Part 5: Python/Django Firebase Integration

### Installation

```bash
pip install firebase-admin
pip install python-dotenv
```

### Configuration

Create `.env` file:
```env
FIREBASE_PROJECT_ID=cargolink-project
FIREBASE_PRIVATE_KEY_ID=your_key_id
FIREBASE_PRIVATE_KEY=your_private_key
FIREBASE_CLIENT_EMAIL=your_email
FIREBASE_CLIENT_ID=your_client_id
FIREBASE_AUTH_URI=https://accounts.google.com/o/oauth2/auth
FIREBASE_TOKEN_URI=https://oauth2.googleapis.com/token
FIREBASE_AUTH_PROVIDER_X509_CERT_URL=https://www.googleapis.com/oauth2/v1/certs
FIREBASE_CLIENT_X509_CERT_URL=your_cert_url
```

### Django Settings Update

```python
# settings.py
import os
from dotenv import load_dotenv
import firebase_admin
from firebase_admin import credentials

load_dotenv()

# Initialize Firebase
if not firebase_admin.get_app():
    firebase_credentials = {
        'type': 'service_account',
        'project_id': os.getenv('FIREBASE_PROJECT_ID'),
        'private_key_id': os.getenv('FIREBASE_PRIVATE_KEY_ID'),
        'private_key': os.getenv('FIREBASE_PRIVATE_KEY'),
        'client_email': os.getenv('FIREBASE_CLIENT_EMAIL'),
        'client_id': os.getenv('FIREBASE_CLIENT_ID'),
        'auth_uri': os.getenv('FIREBASE_AUTH_URI'),
        'token_uri': os.getenv('FIREBASE_TOKEN_URI'),
        'auth_provider_x509_cert_url': os.getenv('FIREBASE_AUTH_PROVIDER_X509_CERT_URL'),
        'client_x509_cert_url': os.getenv('FIREBASE_CLIENT_X509_CERT_URL'),
    }
    
    cred = credentials.Certificate(firebase_credentials)
    firebase_admin.initialize_app(cred)
```

---

## Part 6: User Role-Based Access Control

### Firebase Custom Claims

```python
# services/authentication/auth_service.py

from firebase_admin import auth as firebase_auth

def set_custom_claims(firebase_uid, user_type, admin_role=None):
    """
    Set custom claims for user role-based access
    """
    custom_claims = {
        'userType': user_type,
        'isVerified': user_type != 'Carrier',  # Carriers need verification
        'isActive': True
    }
    
    if user_type == 'Admin':
        custom_claims['adminRole'] = admin_role or 'Support'
    
    firebase_auth.set_custom_user_claims(firebase_uid, custom_claims)
```

### Using Custom Claims in Firestore Rules

Already configured in security rules above.

---

## Part 7: Real-Time Data Sync

### Example: Real-Time Booking Updates

```dart
// Flutter - lib/features/shipper/data/booking_data_source.dart

Stream<Booking> subscribeToBooking(String bookingId) {
  return FirebaseFirestore.instance
      .collection('bookings')
      .doc(bookingId)
      .snapshots()
      .map((snapshot) => Booking.fromMap(snapshot.data() ?? {}));
}
```

### Example: Real-Time Location Tracking

```dart
// Flutter - lib/features/tracking/data/tracking_data_source.dart

Stream<LocationData> subscribeToLiveTracking(String bookingId) {
  return FirebaseFirestore.instance
      .collection('bookings')
      .doc(bookingId)
      .collection('locations')
      .orderBy('timestamp', descending: true)
      .limit(1)
      .snapshots()
      .map((snapshot) {
        final doc = snapshot.docs.first;
        return LocationData.fromMap(doc.data());
      });
}
```

---

## Part 8: Authentication Flow

### Registration Flow

```
1. User enters email, password, phone, selects role
2. Firebase creates auth user
3. Django creates User + role-specific profile
4. Custom claims set in Firebase
5. Firestore profile created
6. Email verification sent
```

### Login Flow

```
1. User logs in with email/password
2. Firebase verifies credentials
3. ID token returned to client
4. Token verified on backend
5. Session established
```

### Token Verification

```python
# services/authentication/auth_service.py

from firebase_admin import auth as firebase_auth

def verify_id_token(id_token):
    try:
        decoded_token = firebase_auth.verify_id_token(id_token)
        user_id = decoded_token['uid']
        custom_claims = decoded_token.get('custom_claims', {})
        return {
            'success': True,
            'uid': user_id,
            'claims': custom_claims
        }
    except Exception as e:
        return {'success': False, 'error': str(e)}
```

---

## Part 9: Testing Credentials

### Test User Accounts

```
Shipper:
- Email: shipper@test.com
- Password: Test@1234
- Phone: +237123456789

Carrier:
- Email: carrier@test.com
- Password: Test@1234
- Phone: +237198765432

Admin:
- Email: admin@test.com
- Password: Test@1234
- Phone: +237100000000
```

---

## Part 10: Cloud Functions (Optional)

### Function: Send Email on Booking Accepted

```javascript
// firebase/functions/index.js

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

admin.initializeApp();

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.GMAIL_USER,
    pass: process.env.GMAIL_PASSWORD
  }
});

exports.notifyBookingAccepted = functions.firestore
  .document('bookings/{bookingId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    
    if (before.status !== 'Accepted' && after.status === 'Accepted') {
      const shipper = await admin.firestore()
        .collection('users')
        .doc(after.shipperId)
        .get();
      
      await transporter.sendMail({
        to: shipper.data().email,
        subject: 'Your booking has been accepted!',
        html: `<p>Your booking ${context.params.bookingId} has been accepted.</p>`
      });
    }
  });
```

---

## Deployment Checklist

- [ ] Firebase project created and configured
- [ ] Authentication methods enabled
- [ ] Firestore security rules deployed
- [ ] Firebase service account key downloaded
- [ ] Flutter apps registered (iOS, Android, Web)
- [ ] Environment variables configured
- [ ] Custom claims configured
- [ ] Test users created
- [ ] Email verification configured
- [ ] Push notifications configured
- [ ] Cloud Functions deployed (if needed)

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Permission denied" in Firestore | Check security rules and ensure user has custom claims |
| Firebase app not initializing | Verify firebase_options.dart has correct credentials |
| Email not sending | Check email verification in Firebase Console |
| Real-time updates not working | Verify Firestore listener has correct path and permissions |

---

## References

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Plugin](https://firebase.flutter.dev/)
- [Firebase Admin SDK for Python](https://firebase.google.com/docs/database/admin/start)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
