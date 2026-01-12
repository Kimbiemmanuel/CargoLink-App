# CargoLink Database Schema Design
## Comprehensive Documentation

This document outlines the complete database schema for the CargoLink logistics platform supporting three user roles: Shipper, Carrier, and Admin.

---

## Database Overview

**Database Type**: PostgreSQL (Recommended) or SQLite (Development)
**ORM**: Django ORM
**Firebase Integration**: Firestore for real-time data and Auth

---

## Core Tables

### 1. USER TABLE (auth_user or users_user)
**Purpose**: Base user model extending Django's AbstractUser

```sql
CREATE TABLE users_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    password VARCHAR(128) NOT NULL,
    last_login DATETIME NULL,
    is_superuser BOOLEAN DEFAULT FALSE,
    username VARCHAR(150) UNIQUE,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    email VARCHAR(254) UNIQUE NOT NULL,
    is_staff BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    date_joined DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- CargoLink Custom Fields
    phone VARCHAR(20) UNIQUE NOT NULL,
    user_type ENUM('Shipper', 'Carrier', 'Admin') NOT NULL,
    is_email_verified BOOLEAN DEFAULT FALSE,
    average_rating FLOAT DEFAULT 0,
    total_ratings INT DEFAULT 0,
    
    UNIQUE INDEX idx_email (email),
    UNIQUE INDEX idx_phone (phone),
    INDEX idx_user_type (user_type),
    INDEX idx_is_active (is_active)
);
```

---

### 2. SHIPPER TABLE
**Purpose**: Store shipper-specific information

```sql
CREATE TABLE users_shipper (
    user_id BIGINT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100) DEFAULT 'Cameroon',
    payment_method_id VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users_user(id) ON DELETE CASCADE,
    INDEX idx_city (city),
    INDEX idx_created_at (created_at)
);
```

---

### 3. CARRIER TABLE
**Purpose**: Store carrier-specific information

```sql
CREATE TABLE users_carrier (
    user_id BIGINT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    license_number VARCHAR(100) UNIQUE NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    is_available BOOLEAN DEFAULT FALSE,
    current_latitude FLOAT,
    current_longitude FLOAT,
    last_location_update DATETIME,
    total_earnings FLOAT DEFAULT 0,
    completed_jobs INT DEFAULT 0,
    bank_account_number VARCHAR(50),
    bank_name VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users_user(id) ON DELETE CASCADE,
    UNIQUE INDEX idx_license (license_number),
    INDEX idx_is_verified (is_verified),
    INDEX idx_is_available (is_available),
    INDEX idx_total_earnings (total_earnings),
    INDEX idx_location (current_latitude, current_longitude)
);
```

---

### 4. ADMIN PROFILE TABLE
**Purpose**: Store admin-specific roles and permissions

```sql
CREATE TABLE users_adminprofile (
    user_id BIGINT PRIMARY KEY,
    admin_name VARCHAR(255) NOT NULL,
    role ENUM('Super_Admin', 'Moderator', 'Support') NOT NULL,
    department VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users_user(id) ON DELETE CASCADE,
    INDEX idx_role (role)
);
```

---

### 5. CARRIER PROFILE TABLE (Vehicles)
**Purpose**: Store vehicle and company information for carriers

```sql
CREATE TABLE users_carrierprofile (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    carrier_id BIGINT UNIQUE NOT NULL,
    vehicle_type ENUM('Bike', 'Van', 'Pickup', 'Small_Truck', 'Large_Truck') NOT NULL,
    vehicle_capacity_kg FLOAT NOT NULL,
    registration_no VARCHAR(50) UNIQUE NOT NULL,
    vehicle_make VARCHAR(100),
    vehicle_model VARCHAR(100),
    year_of_manufacture INT,
    vehicle_color VARCHAR(50),
    insurance_document LONGTEXT,
    insurance_expiry_date DATE,
    inspection_certificate LONGTEXT,
    inspection_expiry_date DATE,
    verified_by BIGINT,
    verification_date DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (carrier_id) REFERENCES users_carrier(user_id) ON DELETE CASCADE,
    FOREIGN KEY (verified_by) REFERENCES users_adminprofile(user_id) ON DELETE SET NULL,
    UNIQUE INDEX idx_registration (registration_no),
    INDEX idx_vehicle_type (vehicle_type)
);
```

---

## Booking & Logistics Tables

### 6. BOOKING TABLE
**Purpose**: Store booking/job information

```sql
CREATE TABLE bookings_booking (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    shipper_id BIGINT NOT NULL,
    carrier_id BIGINT,
    pickup_location VARCHAR(255) NOT NULL,
    pickup_latitude FLOAT NOT NULL,
    pickup_longitude FLOAT NOT NULL,
    dropoff_location VARCHAR(255) NOT NULL,
    dropoff_latitude FLOAT NOT NULL,
    dropoff_longitude FLOAT NOT NULL,
    cargo_type ENUM('Documents', 'Electronics', 'Furniture', 'Food', 'Others') NOT NULL,
    cargo_description TEXT,
    cargo_weight_kg FLOAT NOT NULL,
    cargo_value FLOAT,
    status ENUM(
        'Pending', 'Accepted', 'Picked_Up', 'In_Transit', 'Delivered', 'Cancelled'
    ) DEFAULT 'Pending',
    fare_amount FLOAT NOT NULL,
    distance_km FLOAT,
    estimated_delivery_time INT,  -- in minutes
    actual_delivery_time INT,
    special_instructions TEXT,
    proof_of_delivery_url VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    cancelled_at DATETIME,
    delivered_at DATETIME,
    
    FOREIGN KEY (shipper_id) REFERENCES users_shipper(user_id) ON DELETE CASCADE,
    FOREIGN KEY (carrier_id) REFERENCES users_carrier(user_id) ON DELETE SET NULL,
    INDEX idx_shipper (shipper_id),
    INDEX idx_carrier (carrier_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_pickup (pickup_latitude, pickup_longitude),
    INDEX idx_dropoff (dropoff_latitude, dropoff_longitude)
);
```

---

### 7. LOCATION TRACKING TABLE
**Purpose**: Store real-time location history

```sql
CREATE TABLE bookings_locationtracking (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    booking_id BIGINT NOT NULL,
    carrier_id BIGINT NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    accuracy FLOAT,
    altitude FLOAT,
    speed FLOAT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (booking_id) REFERENCES bookings_booking(id) ON DELETE CASCADE,
    FOREIGN KEY (carrier_id) REFERENCES users_carrier(user_id) ON DELETE CASCADE,
    INDEX idx_booking (booking_id),
    INDEX idx_timestamp (timestamp),
    INDEX idx_location (latitude, longitude)
);
```

---

### 8. DISPUTE TABLE
**Purpose**: Track disputes and complaints

```sql
CREATE TABLE bookings_dispute (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    booking_id BIGINT UNIQUE NOT NULL,
    raised_by BIGINT NOT NULL,
    dispute_type ENUM('Quality', 'Delay', 'Missing_Items', 'Damaged_Goods', 'Other') NOT NULL,
    description TEXT NOT NULL,
    evidence_url VARCHAR(255),
    dispute_status ENUM('Open', 'In_Review', 'Resolved', 'Closed') DEFAULT 'Open',
    resolution TEXT,
    resolved_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at DATETIME,
    
    FOREIGN KEY (booking_id) REFERENCES bookings_booking(id) ON DELETE CASCADE,
    FOREIGN KEY (raised_by) REFERENCES users_user(id) ON DELETE CASCADE,
    FOREIGN KEY (resolved_by) REFERENCES users_adminprofile(user_id) ON DELETE SET NULL,
    INDEX idx_booking (booking_id),
    INDEX idx_status (dispute_status),
    INDEX idx_created_at (created_at)
);
```

---

## Payment & Transaction Tables

### 9. TRANSACTION TABLE
**Purpose**: Store payment transaction records

```sql
CREATE TABLE payments_transaction (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    booking_id BIGINT UNIQUE NOT NULL,
    amount FLOAT NOT NULL,
    net_earnings FLOAT NOT NULL,  -- Carrier's share
    platform_commission FLOAT,  -- CargoLink commission
    payment_method ENUM('Card', 'Mobile_Money', 'Bank_Transfer', 'Wallet') DEFAULT 'Card',
    payment_status ENUM('Pending', 'Processing', 'Completed', 'Failed', 'Refunded') DEFAULT 'Pending',
    stripe_payment_intent_id VARCHAR(255) UNIQUE,
    stripe_charge_id VARCHAR(255),
    transaction_reference VARCHAR(100) UNIQUE,
    payment_date DATETIME,
    payout_date DATETIME,
    failure_reason TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (booking_id) REFERENCES bookings_booking(id) ON DELETE CASCADE,
    INDEX idx_status (payment_status),
    INDEX idx_created_at (created_at),
    INDEX idx_booking (booking_id)
);
```

---

### 10. WALLET TABLE (Optional)
**Purpose**: In-app wallet/balance for carriers

```sql
CREATE TABLE payments_wallet (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    carrier_id BIGINT UNIQUE NOT NULL,
    current_balance FLOAT DEFAULT 0,
    total_earned FLOAT DEFAULT 0,
    total_withdrawn FLOAT DEFAULT 0,
    last_withdrawal_date DATETIME,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (carrier_id) REFERENCES users_carrier(user_id) ON DELETE CASCADE
);
```

---

## Rating & Review Tables

### 11. RATING TABLE
**Purpose**: Store user ratings and reviews

```sql
CREATE TABLE ratings_rating (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    booking_id BIGINT NOT NULL,
    rated_by BIGINT NOT NULL,
    rated_user BIGINT NOT NULL,
    rating FLOAT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    rating_type ENUM('Carrier_Service', 'Shipper_Cooperation', 'General') DEFAULT 'General',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (booking_id) REFERENCES bookings_booking(id) ON DELETE CASCADE,
    FOREIGN KEY (rated_by) REFERENCES users_user(id) ON DELETE CASCADE,
    FOREIGN KEY (rated_user) REFERENCES users_user(id) ON DELETE CASCADE,
    UNIQUE INDEX idx_booking_rater (booking_id, rated_by),
    INDEX idx_rated_user (rated_user),
    INDEX idx_created_at (created_at)
);
```

---

## Notification Tables

### 12. NOTIFICATION TABLE
**Purpose**: Store notification history

```sql
CREATE TABLE core_notification (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    notification_type ENUM(
        'Booking_Status', 'Payment', 'Dispute', 'Rating', 'System', 'Promotion'
    ) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    data LONGTEXT,  -- JSON
    is_read BOOLEAN DEFAULT FALSE,
    read_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users_user(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at)
);
```

---

## Support & Feedback Tables

### 13. SUPPORT TICKET TABLE
**Purpose**: Handle customer support

```sql
CREATE TABLE core_supportticket (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category ENUM('Technical', 'Payment', 'Safety', 'General', 'Other') NOT NULL,
    status ENUM('Open', 'In_Progress', 'Resolved', 'Closed') DEFAULT 'Open',
    priority ENUM('Low', 'Medium', 'High', 'Urgent') DEFAULT 'Medium',
    assigned_to BIGINT,
    attachment_url VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at DATETIME,
    
    FOREIGN KEY (user_id) REFERENCES users_user(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES users_adminprofile(user_id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_status (status),
    INDEX idx_priority (priority)
);
```

---

## Key Relationships Summary

| Table | Relationships |
|-------|--|
| **users_user** | 1:1 with Shipper, Carrier, AdminProfile |
| **users_shipper** | 1:N with Booking (as shipper) |
| **users_carrier** | 1:N with Booking (as carrier), 1:1 with CarrierProfile |
| **bookings_booking** | N:1 with Shipper, N:1 with Carrier, 1:N with LocationTracking, 1:N with Rating |
| **bookings_locationtracking** | N:1 with Booking |
| **payments_transaction** | 1:1 with Booking |
| **ratings_rating** | N:1 with Booking, N:1 with User |
| **bookings_dispute** | 1:1 with Booking |

---

## Indexing Strategy

### Performance Indexes
```sql
-- User lookup optimizations
CREATE INDEX idx_user_email ON users_user(email);
CREATE INDEX idx_user_phone ON users_user(phone);
CREATE INDEX idx_user_type ON users_user(user_type);

-- Booking search and filtering
CREATE INDEX idx_booking_status ON bookings_booking(status);
CREATE INDEX idx_booking_shipper_date ON bookings_booking(shipper_id, created_at DESC);
CREATE INDEX idx_booking_carrier_status ON bookings_booking(carrier_id, status);

-- Location tracking (for map queries)
CREATE INDEX idx_location_booking_time ON bookings_locationtracking(booking_id, timestamp DESC);

-- Payment processing
CREATE INDEX idx_transaction_status ON payments_transaction(payment_status);
CREATE INDEX idx_transaction_date ON payments_transaction(created_at DESC);

-- Notification queries
CREATE INDEX idx_notification_user_unread ON core_notification(user_id, is_read);
```

---

## Views for Common Queries

### Active Bookings View
```sql
CREATE VIEW active_bookings AS
SELECT 
    b.id,
    b.shipper_id,
    b.carrier_id,
    b.status,
    SQRT(POWER(b.dropoff_latitude - b.pickup_latitude, 2) + 
         POWER(b.dropoff_longitude - b.pickup_longitude, 2)) * 111 as distance_km
FROM bookings_booking b
WHERE b.status IN ('Pending', 'Accepted', 'In_Transit', 'Picked_Up')
AND b.created_at > DATE_SUB(NOW(), INTERVAL 7 DAY);
```

### User Statistics View
```sql
CREATE VIEW user_statistics AS
SELECT 
    u.id,
    u.email,
    u.user_type,
    COUNT(DISTINCT b.id) as total_bookings,
    AVG(r.rating) as avg_rating,
    COUNT(DISTINCT r.id) as total_ratings
FROM users_user u
LEFT JOIN bookings_booking b ON u.id = b.shipper_id OR u.id = b.carrier_id
LEFT JOIN ratings_rating r ON r.rated_user = u.id
GROUP BY u.id;
```

---

## Firestore Collections (Parallel to Django)

### Collection: /users/{userId}
```json
{
    "email": "user@example.com",
    "phone": "+237123456789",
    "userType": "Shipper",
    "averageRating": 4.5,
    "isEmailVerified": true,
    "createdAt": "2024-01-12T10:30:00Z",
    "lastLoginAt": "2024-01-12T15:00:00Z"
}
```

### Collection: /bookings/{bookingId}
```json
{
    "shipperId": "user123",
    "carrierId": "carrier456",
    "status": "In_Transit",
    "cargoType": "Electronics",
    "fareAmount": 50000,
    "pickupLocation": {
        "latitude": 3.8667,
        "longitude": 11.5167
    },
    "dropoffLocation": {
        "latitude": 4.0511,
        "longitude": 9.7679
    },
    "createdAt": "2024-01-12T10:30:00Z"
}
```

### Collection: /locationTracking/{bookingId}/locations
```json
{
    "latitude": 3.8667,
    "longitude": 11.5167,
    "timestamp": "2024-01-12T15:30:00Z",
    "accuracy": 5.5
}
```

---

## Backup & Security

- **Backup Frequency**: Daily automated backups
- **Encryption**: All sensitive data encrypted at rest
- **Retention**: Keep backups for 30 days minimum
- **PII Fields**: Encrypt phone, payment information

---

## Migration Notes

1. Run Django migrations for each app:
   ```bash
   python manage.py migrate users
   python manage.py migrate bookings
   python manage.py migrate payments
   python manage.py migrate ratings
   ```

2. Create initial admin user:
   ```bash
   python manage.py createsuperuser
   ```

3. Set up Firebase Firestore rules for real-time data sync

4. Configure Stripe webhook endpoints for payment confirmations

---

## Future Enhancements

- [ ] Add promotion/discount codes table
- [ ] Implement loyalty program tables
- [ ] Add feedback survey responses
- [ ] Implement batch booking support
- [ ] Add route optimization data
