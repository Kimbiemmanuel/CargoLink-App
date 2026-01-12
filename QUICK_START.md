# CargoLink Quick Start Guide

Get the CargoLink platform running in 30 minutes.

---

## 📋 Prerequisites (5 minutes)

### Required Accounts
- [ ] Firebase project (https://console.firebase.google.com)
- [ ] Stripe test account (https://dashboard.stripe.com)
- [ ] GitHub account (optional, for version control)

### Required Software
- [ ] Python 3.10+ (`python --version`)
- [ ] Flutter 3.10+ (`flutter --version`)
- [ ] Git (`git --version`)

---

## ⚡ Quick Setup (25 minutes)

### Step 1: Clone Repository (2 minutes)

```bash
cd c:\Users\GLC\Desktop\WorkSpace\CargoLink-App\cargolink_app
```

### Step 2: Backend Setup (8 minutes)

```bash
# Create virtual environment
python -m venv venv

# Activate it
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create .env file from template
copy .env.example .env

# Edit .env with your credentials (Firebase, Stripe, Email)
# Open with notepad or your editor:
notepad .env
```

**What to add to .env:**
```env
SECRET_KEY=django-insecure-your-secret-key
DEBUG=True

# Firebase (get from Firebase Console)
FIREBASE_PROJECT_ID=cargolink-project
FIREBASE_PRIVATE_KEY=your_private_key
FIREBASE_CLIENT_EMAIL=your_email@iam.gserviceaccount.com

# Stripe (get from Stripe Dashboard)
STRIPE_PUBLIC_KEY=pk_test_your_key
STRIPE_SECRET_KEY=sk_test_your_key
```

### Step 3: Database Setup (5 minutes)

```bash
# Apply migrations
python manage.py migrate users
python manage.py migrate bookings
python manage.py migrate payments
python manage.py migrate ratings

# Create admin user
python manage.py createsuperuser
# Email: admin@test.com
# Password: Admin@123

# (Optional) Load sample data
python manage.py loaddata fixtures/initial_data.json
```

### Step 4: Flutter Setup (10 minutes)

```bash
# Get dependencies
flutter pub get

# Configure Firebase (select your project)
flutterfire configure --project=cargolink-project

# When prompted, select:
# - iOS: Yes
# - Android: Yes
# - Web: Yes (optional)

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🚀 Start the Application (3 minutes)

### Terminal 1: Django Backend

```bash
venv\Scripts\activate
python manage.py runserver
```

✅ Backend running at: **http://localhost:8000**
✅ Admin panel at: **http://localhost:8000/admin**

### Terminal 2: Flutter App

```bash
flutter run -d chrome
# or use your device/emulator
```

✅ App running in browser or on device

---

## 🧪 Test the Application (5 minutes)

### 1. Test Backend API

```bash
# Open in browser or use curl
curl http://localhost:8000/api/auth/login/

# Should return error (expected - need POST data)
# This confirms API is working
```

### 2. Test Admin Panel

```
Navigate to: http://localhost:8000/admin
Login with: admin@test.com / Admin@123
```

### 3. Test Flutter App

```
1. Open app in browser
2. Click "Register"
3. Enter test data:
   - Email: shipper@test.com
   - Password: Test@1234
   - Phone: +237123456789
   - Role: Shipper
4. Click "Register"
```

---

## 📁 Important Files to Know

### Core Configuration

| File | What | Edit? |
|------|------|-------|
| `.env` | Secrets & credentials | ✅ YES - Add your keys |
| `pubspec.yaml` | Flutter dependencies | ❌ No - Already configured |
| `requirements.txt` | Python dependencies | ❌ No - Already configured |
| `cargolink_backend/settings.py` | Django config | ⚠️ Maybe - Most is done |

### Documentation (Read First!)

| File | Read for... |
|------|------------|
| `PROJECT_SETUP_GUIDE.md` | Detailed setup & structure |
| `DATABASE_SCHEMA.md` | Database design |
| `FIREBASE_SETUP.md` | Firebase configuration |
| `ARCHITECTURE.md` | How everything works together |

---

## 🛠️ Common Issues & Solutions

### Issue: "ModuleNotFoundError"

```bash
# Solution: Check venv is activated
venv\Scripts\activate

# Reinstall packages
pip install -r requirements.txt
```

### Issue: "Firebase initialization error"

```bash
# Solution: Check .env has correct Firebase credentials
# 1. Go to Firebase Console
# 2. Project Settings → Service Accounts
# 3. Copy JSON key and extract values to .env
```

### Issue: "Port 8000 already in use"

```bash
# Solution: Change port
python manage.py runserver 8001
```

### Issue: "Flutter app won't connect to backend"

```bash
# Solution: Update API URL in app if needed
# File: lib/core/constants.dart
# Change: static const String baseUrl = 'http://localhost:8000/api';
```

---

## 📊 Project Structure Quick Reference

```
cargolink_app/
├── lib/                    ← Flutter code
│   ├── config/            ← App configuration
│   ├── core/              ← Shared utilities
│   └── features/          ← Feature modules
│
├── cargolink_backend/      ← Django backend
│   ├── settings.py        ← Configuration
│   └── services/          ← Business logic
│
├── users/                  ← Django app: Users
├── bookings/               ← Django app: Bookings
├── payments/               ← Django app: Payments
├── ratings/                ← Django app: Ratings
│
├── DATABASE_SCHEMA.md      ← Database design
├── FIREBASE_SETUP.md       ← Firebase guide
├── ARCHITECTURE.md         ← System design
└── PROJECT_SETUP_GUIDE.md  ← Detailed setup
```

---

## 🎯 What's Ready to Develop

### You Can Implement

✅ **Backend API Endpoints** - Use the services as a guide
✅ **Flutter Screens** - Repositories are defined
✅ **Authentication Flows** - Firebase is configured
✅ **Database Models** - Schema is complete
✅ **Payments** - Stripe integration is ready

### Already Done for You

✅ Folder structure organized
✅ Dependencies configured
✅ Firebase setup guide
✅ Database schema designed
✅ Service interfaces defined
✅ Configuration templated

---

## 🔐 Security Notes

⚠️ **Before Production**:
- [ ] Change SECRET_KEY in .env
- [ ] Set DEBUG=False
- [ ] Enable HTTPS
- [ ] Setup proper database (PostgreSQL)
- [ ] Configure email service
- [ ] Review Firebase security rules
- [ ] Setup environment-specific .env files

---

## 📞 Need Help?

1. **Setup Questions**: See `PROJECT_SETUP_GUIDE.md`
2. **Database Questions**: See `DATABASE_SCHEMA.md`
3. **Firebase Questions**: See `FIREBASE_SETUP.md`
4. **Architecture Questions**: See `ARCHITECTURE.md`
5. **API Questions**: See API endpoints in `PROJECT_SETUP_GUIDE.md`

---

## ✅ Next Steps

1. **Complete this Quick Start** (you're almost there!)
2. **Read `ARCHITECTURE.md`** - Understand how it works
3. **Start Implementing**:
   - Backend: Create API views
   - Frontend: Implement screens
   - Database: Run migrations
4. **Test Everything** - Use the test credentials provided
5. **Deploy** - Follow deployment guide in `ARCHITECTURE.md`

---

## 🚀 Success Checklist

- [ ] Clone repository
- [ ] Backend running (http://localhost:8000)
- [ ] Admin panel accessible
- [ ] Flutter app running
- [ ] Can create test user
- [ ] Can see API in browser
- [ ] All .env values filled in

---

**You're ready to develop! 🎉**

---

*Quick Start Guide - January 12, 2025*
