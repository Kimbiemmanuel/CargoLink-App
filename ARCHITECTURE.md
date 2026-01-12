# CargoLink System Architecture

## Overview

CargoLink is a modern, scalable logistics platform built with a microservices-inspired architecture, separating concerns across frontend, backend, and real-time services.

```
┌─────────────────────────────────────────────────────────────────┐
│                     CLIENT APPLICATIONS                          │
├─────────────────────────────────────────────────────────────────┤
│  Flutter Apps (iOS, Android, Web) - Cross-platform delivery     │
└────────────┬────────────────┬────────────────┬──────────────────┘
             │                │                │
      ┌──────▼──────┐  ┌──────▼──────┐  ┌─────▼───────┐
      │   Shipper   │  │   Carrier   │  │    Admin    │
      │   App       │  │   App       │  │    Portal   │
      └──────┬──────┘  └──────┬──────┘  └─────┬───────┘
             │                │                │
             └────────────┬───┴────────────┬───┘
                          │
        ┌─────────────────▼─────────────────┐
        │     Firebase Authentication        │
        │     & Real-time Database           │
        │     (Firestore)                    │
        └──────┬────────────────────────────┘
               │
        ┌──────▼──────────────────────────────┐
        │   REST API Layer (Django DRF)       │
        │   http://localhost:8000/api         │
        └──────┬───────────────────┬──────────┘
               │                   │
      ┌────────▼──────┐   ┌────────▼──────┐
      │   API Routes  │   │  WebSocket    │
      │   & Handlers  │   │  Channels     │
      └────────┬──────┘   └────────┬──────┘
               │                   │
        ┌──────▼───────────────────▼──────────┐
        │        Business Logic Services       │
        ├──────────────────────────────────────┤
        │  • Authentication Service            │
        │  • Payments Service (Stripe)         │
        │  • Tracking Service (GPS/Location)   │
        │  • Admin Service (Management)        │
        │  • Notifications Service             │
        └──────┬───────────────────┬──────────┘
               │                   │
      ┌────────▼──────┐   ┌────────▼──────┐
      │  Django ORM   │   │   Celery      │
      │  (Database    │   │   (Async      │
      │   Models)     │   │    Tasks)     │
      └────────┬──────┘   └────────┬──────┘
               │                   │
        ┌──────▼───────────────────▼──────────┐
        │       Data Layer (Persistence)      │
        ├──────────────────────────────────────┤
        │  PostgreSQL / SQLite                 │
        │  Redis (Cache & Message Queue)       │
        │  Firestore (Real-time Sync)          │
        └──────────────────────────────────────┘
               │                   │
      ┌────────▼──────┐   ┌────────▼──────┐
      │   External    │   │   Cloud       │
      │   Services    │   │   Functions   │
      │   • Stripe    │   │   • Email     │
      │   • Firebase  │   │   • SMS       │
      │   • Maps API  │   │   • Webhooks  │
      └───────────────┘   └───────────────┘
```

---

## Architecture Layers

### 1. **Presentation Layer** (Flutter)

**Responsible for**: User interface and user experience

```
lib/
├── features/
│   ├── auth/          - Authentication UI (login, register, password reset)
│   ├── shipper/       - Shipper-specific screens
│   ├── carrier/       - Carrier-specific screens
│   ├── admin/         - Admin dashboard & management
│   ├── tracking/      - Real-time tracking maps
│   ├── payments/      - Payment UI & confirmation
│   └── ratings/       - Rating & review screens
├── config/            - App configuration (routes, theme)
└── core/              - Shared models & utilities
```

**Technology**: Flutter 3.10+, Riverpod (State Management)

**Key Responsibilities**:
- User authentication flows
- Booking creation & management
- Real-time location tracking UI
- Payment processing UI
- Admin dashboards
- Push notifications display

---

### 2. **API Gateway Layer** (Django REST Framework)

**Responsible for**: HTTP request routing, authentication, validation

```
cargolink_backend/
├── urls.py            - Route configuration
├── middleware/        - Request/response processing
├── permissions/       - Authorization checks
└── validators/        - Input validation
```

**Key Features**:
- Token-based authentication (Django TokenAuth)
- CORS configuration
- Rate limiting
- Request logging
- Error handling

**Endpoints Structure**:
```
/api/
├── auth/
│   ├── register
│   ├── login
│   └── verify-token
├── shipper/
│   ├── profile
│   ├── bookings
│   └── payments
├── carrier/
│   ├── profile
│   ├── available-bookings
│   └── location
├── admin/
│   ├── users
│   ├── disputes
│   └── reports
└── tracking/
    └── location
```

---

### 3. **Business Logic Layer** (Services)

**Responsible for**: Core business operations

```
cargolink_backend/services/
├── authentication/auth_service.py
├── payments/payments_service.py
├── tracking/tracking_service.py
├── admin/admin_service.py
└── notifications/notifications_service.py
```

#### AuthenticationService
```python
- register_user()              - User registration
- verify_firebase_token()      - Token verification
- login_user()                 - User login
- logout_user()                - User logout
- reset_password()             - Password reset
- set_custom_claims()          - Firebase claims
```

#### PaymentsService
```python
- create_payment_intent()      - Stripe payment intent
- confirm_payment()            - Payment confirmation
- get_transaction_history()    - Transaction records
- process_refund()             - Refund handling
```

#### TrackingService
```python
- update_location()            - Real-time location update
- get_current_location()       - Current location
- get_location_history()       - Location history
- calculate_distance()         - Distance calculation
```

#### AdminService
```python
- get_dashboard_stats()        - System statistics
- verify_carrier()             - Carrier verification
- suspend_user()               - User suspension
- resolve_dispute()            - Dispute resolution
- get_reports()                - System reports
```

#### NotificationsService
```python
- send_email()                 - Email notifications
- send_sms()                   - SMS notifications
- send_push_notification()     - Push notifications
- notify_booking_accepted()    - Booking notifications
- notify_carrier_new_booking() - New job alerts
```

---

### 4. **Data Access Layer** (Models & ORM)

**Responsible for**: Database interactions

```
users/models.py
├── User                - Base user model
├── Shipper             - Shipper profile
├── Carrier             - Carrier profile
├── AdminProfile        - Admin profile
└── CarrierProfile      - Vehicle details

bookings/models.py
├── Booking             - Booking/job record
├── LocationTracking    - GPS coordinates history
└── Dispute             - Dispute/complaint

payments/models.py
├── Transaction         - Payment transaction
└── Wallet              - Carrier earnings

ratings/models.py
└── Rating              - User ratings & reviews
```

**ORM Features**:
- Relationships (ForeignKey, OneToOneField)
- Indexing for performance
- Soft deletes (if needed)
- Timestamps (created_at, updated_at)

---

### 5. **Persistence Layer** (Databases)

#### PostgreSQL (Primary Database)

**Tables**: 13 tables organized by domain

```
User Management
├── users_user
├── users_shipper
├── users_carrier
├── users_adminprofile
└── users_carrierprofile

Logistics
├── bookings_booking
├── bookings_locationtracking
└── bookings_dispute

Payments
├── payments_transaction
└── payments_wallet (optional)

Ratings
└── ratings_rating

Support
└── core_supportticket
└── core_notification
```

**See**: [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) for complete schema

#### Redis (Cache & Message Queue)

```
cache/
├── user_sessions:{userId}
├── booking_data:{bookingId}
└── location_cache:{bookingId}

queues/
├── email_tasks
├── sms_tasks
├── notification_tasks
└── background_jobs
```

#### Firestore (Real-time Synchronization)

```
/users/{userId}                    - User profiles
/bookings/{bookingId}              - Active bookings
  /locations/{locationId}          - Real-time tracking
/ratings/{ratingId}                - Reviews
/notifications/{userId}/{notId}    - User notifications
/admin/settings                    - Admin configuration
```

---

## Data Flow Examples

### Example 1: Booking Creation Flow

```
1. Shipper Mobile App
   └─ POST /api/shipper/bookings/
      ├─ Request: {pickup, dropoff, cargoType, weight}
      └─ Header: Authorization: Token <token>

2. API Gateway (Django)
   ├─ Verify token (Firebase)
   ├─ Validate input (address, coordinates, weight)
   ├─ Check permissions (Is Shipper?)
   └─ Route to BookingService

3. BusinessLogic (Booking Service)
   ├─ Calculate fare (distance × rate)
   ├─ Create Booking record (status: "Pending")
   ├─ Save to PostgreSQL
   ├─ Sync to Firestore
   └─ Trigger notification service

4. Notifications Service
   ├─ Notify nearby available carriers
   ├─ Send FCM push notifications
   └─ Create notification records

5. Response
   └─ Return: {bookingId, fare, estimatedTime}

6. Real-time Update (WebSocket)
   ├─ Firestore listener triggers
   ├─ Flutter app receives update
   └─ UI displays booking confirmation
```

### Example 2: Real-time Location Tracking

```
1. Carrier Mobile App (Every 5-10 seconds)
   └─ PUT /api/carrier/location/
      ├─ Request: {latitude, longitude, accuracy}
      └─ Header: Authorization: Token <token>

2. API Gateway
   ├─ Validate token
   ├─ Rate limiting (prevent spam)
   └─ Route to TrackingService

3. Tracking Service
   ├─ Create LocationTracking record
   ├─ Save to PostgreSQL
   ├─ Sync to Firestore
   ├─ Cache in Redis
   ├─ Broadcast via WebSocket
   └─ Calculate ETA

4. WebSocket Broadcast
   ├─ Send to booking channel
   ├─ Update map in real-time
   └─ Notify shipper

5. Background Job (Celery)
   ├─ Update estimated delivery time
   ├─ Check for geofencing
   └─ Trigger arrival notification
```

### Example 3: Payment Processing

```
1. Shipper App
   └─ POST /api/payments/initiate/
      ├─ Request: {bookingId, amount}
      └─ Header: Authorization: Token <token>

2. Payments Service
   ├─ Verify booking exists
   ├─ Create Stripe PaymentIntent
   ├─ Return client secret to app
   └─ Create pending Transaction record

3. Shipper Completes Payment (Stripe)
   ├─ Client-side confirmation
   └─ Stripe webhook callback

4. Webhook Handler
   ├─ Verify signature
   ├─ Update Transaction status
   ├─ Process carrier payout
   ├─ Update carrier earnings
   └─ Send confirmation email

5. Real-time Updates
   ├─ Sync to Firestore
   ├─ Trigger notifications
   └─ Update app UI
```

---

## Security Architecture

### Authentication Flow

```
┌─────────────┐
│   User      │
├─────────────┤
│  Email      │
│  Password   │
└────┬────────┘
     │
     ▼
┌────────────────────────────────────┐
│  Firebase Authentication            │
│  • Verify credentials               │
│  • Generate ID Token                │
│  • Set custom claims                │
└────┬───────────────────────────────┘
     │
     ▼
┌────────────────────────────────────┐
│  Client Receives:                  │
│  • ID Token (valid 1 hour)          │
│  • Refresh Token                    │
│  • User UID                         │
└────┬───────────────────────────────┘
     │
     ▼
┌────────────────────────────────────┐
│  API Request                       │
│  • Include ID Token in header      │
│  • X-Firebase-Token: <token>       │
└────┬───────────────────────────────┘
     │
     ▼
┌────────────────────────────────────┐
│  Django Verification               │
│  • Extract token from header       │
│  • Call firebase_auth.verify()     │
│  • Check custom claims             │
│  • Validate user permissions       │
└────┬───────────────────────────────┘
     │
     ▼
┌────────────────────────────────────┐
│  Request Allowed/Denied            │
└────────────────────────────────────┘
```

### Authorization Matrix

| Role | Auth Endpoint | Bookings | Payments | Admin |
|------|---|---|---|---|
| **Shipper** | ✅ Register/Login | Create, View, Rate | View, Pay | ❌ |
| **Carrier** | ✅ Register/Login | View Available, Accept | View Earnings | ❌ |
| **Admin** | ✅ Login | View All | View All | ✅ |

### Data Protection

- **In Transit**: HTTPS/TLS encryption
- **At Rest**: Database encryption, Firebase security rules
- **Sensitive Data**: PII fields encrypted
- **Rate Limiting**: Prevent brute force attacks
- **Input Validation**: Server-side validation for all inputs
- **SQL Injection**: Django ORM prevents SQL injection
- **CSRF Protection**: Django CSRF middleware

---

## Scalability Considerations

### Horizontal Scaling

```
Load Balancer
├── Django Server 1
├── Django Server 2
├── Django Server 3
└── Django Server N

Shared Resources:
├── PostgreSQL (Replicated)
├── Redis Cluster
└── Firebase (Managed)
```

### Database Optimization

- **Indexing**: Strategic indexes on frequently queried columns
- **Partitioning**: Bookings table partitioned by date
- **Caching**: Redis for session, booking data, location cache
- **Query Optimization**: Select specific fields, avoid N+1 queries

### Async Processing (Celery)

Long-running tasks moved to background:
- Email sending
- Notification delivery
- Report generation
- Image processing
- Webhook retries

---

## Monitoring & Observability

```
Application Logs (Django)
├── Request/Response logs
├── Error logs
├── Business logic logs
└── External API call logs

Performance Metrics (Sentry/Datadog)
├── Response time
├── Error rates
├── User actions
└── System health

Database Monitoring
├── Query performance
├── Connection pool usage
├── Slow query logs
└── Replication lag

Firestore Metrics
├── Document reads/writes
├── Index usage
├── Storage consumption
└── Real-time listener health
```

---

## Deployment Topology

### Development
```
Local Machine:
├── Django (runserver)
├── SQLite Database
├── Redis (localhost)
└── Firebase (shared dev project)
```

### Staging
```
AWS EC2:
├── Django (Gunicorn + Nginx)
├── PostgreSQL (RDS)
├── Redis (ElastiCache)
└── Firebase (staging project)
```

### Production
```
Multi-zone Deployment:
├── Load Balancer (AWS ALB)
├── Auto Scaling Group (EC2 instances)
├── PostgreSQL (Multi-AZ)
├── Redis Cluster (Multi-AZ)
├── CDN (CloudFront)
└── Firebase (production project)
```

---

## Technology Choices Rationale

| Component | Choice | Why |
|-----------|--------|-----|
| **Mobile Framework** | Flutter | Cross-platform (iOS, Android, Web) |
| **Backend Framework** | Django DRF | Mature, batteries-included, ORM |
| **Database** | PostgreSQL | ACID compliance, JSON support, scalable |
| **Real-time** | Firestore | Managed, real-time sync, global distribution |
| **Authentication** | Firebase Auth | Secure, scalable, multi-provider support |
| **Payments** | Stripe | Industry standard, PCI compliant, reliable |
| **Maps** | Google Maps | Comprehensive, reliable, widely supported |
| **Caching** | Redis | Fast, supports pub/sub, session storage |
| **Task Queue** | Celery | Distributed, reliable, Pythonic |
| **API Documentation** | DRF Spectacular | OpenAPI 3.0, interactive docs |

---

## Future Architecture Enhancements

1. **Microservices Migration**
   - Separate services: Auth, Bookings, Payments, Tracking
   - API Gateway (Kong/Tyk)
   - Service mesh (Istio)

2. **Event-Driven Architecture**
   - Event broker (Kafka/RabbitMQ)
   - Event handlers for business logic
   - CQRS pattern for read/write separation

3. **GraphQL API**
   - Add GraphQL layer alongside REST
   - Real-time subscriptions
   - Better query flexibility

4. **AI/ML Integration**
   - Route optimization
   - Demand forecasting
   - Fraud detection
   - ETA prediction

5. **Advanced Caching**
   - Redis clusters
   - Cache warming strategies
   - CDN for static assets

---

## References

- [Django Documentation](https://docs.djangoproject.com/)
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Redis Documentation](https://redis.io/documentation)

---

**Last Updated**: January 12, 2025
**Version**: 1.0
