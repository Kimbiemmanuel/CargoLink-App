# CargoLink Project - Comprehensive Setup Guide

This is a complete guide to get the CargoLink logistics platform up and running.

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Prerequisites](#prerequisites)
3. [Project Structure](#project-structure)
4. [Backend Setup](#backend-setup)
5. [Frontend Setup](#frontend-setup)
6. [Database Setup](#database-setup)
7. [Firebase Configuration](#firebase-configuration)
8. [Running the Application](#running-the-application)
9. [API Documentation](#api-documentation)
10. [Deployment Guide](#deployment-guide)

---

## 📱 Project Overview

**CargoLink** is a comprehensive logistics platform that enables:
- **Shippers** to request cargo deliveries
- **Carriers** to accept and deliver shipments
- **Admins** to manage users, disputes, and platform operations

### Technology Stack

**Frontend**: Flutter (Cross-platform mobile app)
**Backend**: Django REST Framework (Python)
**Real-time**: Firebase (Firestore + Authentication)
**Payments**: Stripe API
**Database**: PostgreSQL (Production) / SQLite (Development)
**Maps**: Google Maps
**Cloud**: Firebase Cloud Functions

---

## 🔧 Prerequisites

### System Requirements
- Python 3.10+
- Node.js 16+
- Flutter SDK 3.10+
- PostgreSQL 12+ (for production)
- Redis 6+ (for caching and Celery)
- Docker (optional, for containerization)

### Required Accounts
- [ ] Firebase Project
- [ ] Stripe Account
- [ ] Google Cloud Account (for Maps/Cloud Functions)
- [ ] Email service (Gmail/SendGrid)
- [ ] AWS S3 (optional, for file storage)

---

## 📁 Project Structure

```
cargolink_app/
├── lib/                              # Flutter frontend
│   ├── config/                       # App configuration
│   │   ├── firebase_config.dart
│   │   ├── app_routes.dart
│   │   └── app_theme.dart
│   ├── core/                         # Core utilities
│   │   ├── constants.dart
│   │   ├── exceptions.dart
│   │   └── models.dart
│   ├── features/                     # Feature modules
│   │   ├── auth/                     # Authentication
│   │   ├── shipper/                  # Shipper functionality
│   │   ├── carrier/                  # Carrier functionality
│   │   ├── admin/                    # Admin functionality
│   │   ├── tracking/                 # Real-time tracking
│   │   ├── payments/                 # Payment processing
│   │   └── ratings/                  # User ratings
│   └── main.dart
│
├── cargolink_backend/               # Django backend
│   ├── settings.py                  # Main configuration
│   ├── urls.py                      # URL routing
│   ├── wsgi.py
│   ├── asgi.py
│   ├── services/                    # Business logic services
│   │   ├── authentication/
│   │   ├── payments/
│   │   ├── tracking/
│   │   ├── admin/
│   │   └── notifications/
│   ├── common/                      # Shared utilities
│   │   ├── middleware/
│   │   ├── permissions/
│   │   ├── validators/
│   │   └── utils/
│   └── core/
│
├── users/                           # Django app - User management
│   ├── models.py                    # User, Shipper, Carrier, Admin
│   ├── views.py
│   ├── serializers.py
│   └── migrations/
│
├── bookings/                        # Django app - Booking management
│   ├── models.py                    # Booking, LocationTracking
│   ├── views.py
│   └── migrations/
│
├── payments/                        # Django app - Payment handling
│   ├── models.py                    # Transaction, Wallet
│   ├── views.py
│   └── migrations/
│
├── ratings/                         # Django app - Rating system
│   ├── models.py                    # Rating model
│   ├── views.py
│   └── migrations/
│
├── DATABASE_SCHEMA.md               # Complete database schema
├── FIREBASE_SETUP.md               # Firebase setup guide
├── ARCHITECTURE.md                 # System architecture
├── API_DOCUMENTATION.md            # API endpoints
├── pubspec.yaml                    # Flutter dependencies
├── manage.py                       # Django management
├── requirements.txt                # Python dependencies
└── .env.example                    # Environment template
```

---

## 🚀 Backend Setup

### Step 1: Clone and Install

```bash
cd cargolink_app
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### Step 2: Environment Configuration

```bash
# Copy example env file
cp .env.example .env

# Edit .env with your configuration
# Set all Firebase, Stripe, and database credentials
```

### Step 3: Database Setup

```bash
# Apply migrations
python manage.py migrate users
python manage.py migrate bookings
python manage.py migrate payments
python manage.py migrate ratings

# Create superuser
python manage.py createsuperuser

# Load initial data (optional)
python manage.py loaddata fixtures/initial_data.json
```

### Step 4: Verify Installation

```bash
# Run tests
python manage.py test

# Start development server
python manage.py runserver

# Access admin panel
# Navigate to http://localhost:8000/admin
```

---

## 📱 Frontend Setup

### Step 1: Install Flutter Dependencies

```bash
cd cargolink_app
flutter pub get

# Generate code for Riverpod and Hive
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 2: Configure Firebase

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure your Flutter app
flutterfire configure --project=cargolink-project

# Select platforms (ios, android, web, macos, windows, linux)
```

### Step 3: Update Firebase Options

Edit `lib/config/firebase_options.dart` with your Firebase project credentials.

### Step 4: Run the App

```bash
# For development
flutter run

# For specific platform
flutter run -d android    # Android emulator
flutter run -d ios        # iOS simulator
flutter run -d chrome     # Web browser
```

---

## 🗄️ Database Setup

### Option 1: SQLite (Development)

Default in Django settings. Just run migrations.

### Option 2: PostgreSQL (Production)

```bash
# Install PostgreSQL
# Create database
createdb cargolink_db

# Update .env
# DB_ENGINE=django.db.backends.postgresql
# DB_NAME=cargolink_db
# DB_USER=postgres
# DB_PASSWORD=your_password

# Run migrations
python manage.py migrate
```

### Database Tables

See [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) for complete schema documentation including:
- User tables (User, Shipper, Carrier, AdminProfile)
- Booking & Tracking tables
- Payment & Transaction tables
- Rating & Review tables
- Support & Feedback tables

---

## 🔐 Firebase Configuration

Complete Firebase setup is documented in [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

### Quick Firebase Setup

1. Create project at https://console.firebase.google.com
2. Enable Authentication (Email, Phone, Google)
3. Set up Firestore Database
4. Configure Security Rules
5. Download service account key
6. Add credentials to `.env`

### Firestore Collections

```
users/              - User profiles
shippers/           - Shipper details
carriers/           - Carrier details
bookings/           - Active bookings
payments/           - Payment records
ratings/            - User ratings
notifications/      - User notifications
admin/              - Admin settings
```

---

## ▶️ Running the Application

### Development Environment

**Terminal 1 - Django Backend**:
```bash
source venv/bin/activate
python manage.py runserver
# Server running at http://localhost:8000
```

**Terminal 2 - Flutter App**:
```bash
flutter run -d chrome
# or choose your device
```

**Terminal 3 - Celery (Optional - for async tasks)**:
```bash
source venv/bin/activate
celery -A cargolink_backend worker -l info
```

### Production Deployment

See [DEPLOYMENT_GUIDE.md](#deployment-guide) for:
- Docker containerization
- Server configuration
- SSL/HTTPS setup
- Database backups
- CI/CD pipelines

---

## 📚 API Documentation

### Authentication Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/api/auth/register/` | User registration |
| POST | `/api/auth/login/` | User login |
| POST | `/api/auth/logout/` | User logout |
| POST | `/api/auth/verify-token/` | Verify Firebase token |
| POST | `/api/auth/reset-password/` | Password reset |

### Shipper Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/shipper/profile/` | Get shipper profile |
| PUT | `/api/shipper/profile/` | Update profile |
| POST | `/api/shipper/bookings/` | Create booking |
| GET | `/api/shipper/bookings/` | List bookings |
| GET | `/api/shipper/bookings/{id}/` | Get booking details |
| POST | `/api/shipper/bookings/{id}/rate/` | Rate carrier |

### Carrier Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/carrier/profile/` | Get profile |
| GET | `/api/carrier/bookings/available/` | Get available jobs |
| POST | `/api/carrier/bookings/{id}/accept/` | Accept booking |
| PUT | `/api/carrier/location/` | Update location |
| GET | `/api/carrier/earnings/` | Get earnings |

### Admin Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/admin/dashboard/` | Dashboard stats |
| GET | `/api/admin/users/` | List all users |
| POST | `/api/admin/carriers/{id}/verify/` | Verify carrier |
| GET | `/api/admin/disputes/` | List disputes |
| POST | `/api/admin/disputes/{id}/resolve/` | Resolve dispute |

See [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for complete endpoint documentation.

---

## 🚀 Deployment Guide

### Docker Deployment

Create `Dockerfile`:
```dockerfile
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["gunicorn", "cargolink_backend.wsgi:application", "--bind", "0.0.0.0:8000"]
```

Create `docker-compose.yml`:
```yaml
version: '3.8'
services:
  postgres:
    image: postgres:14
    environment:
      POSTGRES_DB: cargolink_db
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
  
  redis:
    image: redis:7
    ports:
      - "6379:6379"
  
  web:
    build: .
    ports:
      - "8000:8000"
    depends_on:
      - postgres
      - redis
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@postgres:5432/cargolink_db
      - REDIS_URL=redis://redis:6379/0
```

Deploy:
```bash
docker-compose up -d
```

### Cloud Deployment Options

- **Google Cloud Run**: Containerized Django + Firestore
- **AWS EC2**: Traditional server setup
- **Heroku**: Quick deployment (limited free tier)
- **DigitalOcean**: Affordable and reliable

---

## 📊 Project Statistics

- **Flutter Files**: 50+ dart files
- **Django Apps**: 4 apps (users, bookings, payments, ratings)
- **Database Tables**: 13 tables
- **API Endpoints**: 30+ endpoints
- **Firebase Collections**: 8+ collections
- **Security Rules**: Comprehensive Firestore rules

---

## 🆘 Troubleshooting

### Backend Issues

**Django Migration Errors**:
```bash
python manage.py migrate --fake-initial
python manage.py migrate
```

**Firebase Connection Error**:
```bash
# Verify .env has correct credentials
# Check Firebase project is active
# Ensure service account has appropriate permissions
```

### Frontend Issues

**Flutter Build Error**:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Hot Reload Not Working**:
```bash
# Stop the app
# Run again
flutter run
```

### Database Issues

**PostgreSQL Connection Failed**:
```bash
# Verify PostgreSQL is running
pg_isready -h localhost

# Check credentials in .env
# Ensure database exists
createdb cargolink_db
```

---

## 📞 Support & Documentation

- **API Docs**: [API_DOCUMENTATION.md](API_DOCUMENTATION.md)
- **Database Schema**: [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)
- **Firebase Setup**: [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
- **Architecture**: [ARCHITECTURE.md](ARCHITECTURE.md)

---

## 🔄 Next Steps

1. ✅ Complete Firebase setup
2. ✅ Configure environment variables
3. ✅ Run database migrations
4. ✅ Start backend server
5. ✅ Launch Flutter app
6. ✅ Test user flows (register, book, track, pay)
7. ✅ Deploy to production

---

## 📝 License

This project is proprietary software. All rights reserved.

---

**Last Updated**: January 12, 2025
**Version**: 1.0.0-setup
