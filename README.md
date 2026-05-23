---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0+)
* [Python](https://www.python.org/downloads/) (v3.12+)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
* [Git](https://git-scm.com/)

---

### 1️⃣ Backend Setup — Docker (Recommended)

```bash
cd backend

# Copy environment template and fill in your values
cp .env.example .env

# Build and start all services (Django + PostgreSQL + Redis + Celery)
docker compose up --build

# In a second terminal, run migrations
docker compose exec backend python manage.py migrate

# Verify everything is healthy
curl http://localhost:8000/health/
# Expected: {"status": "healthy", "checks": {"database": "ok", "cache": "ok"}}
```

### 2️⃣ Backend Setup — Local (Without Docker)

```bash
cd backend

# Create and activate virtual environment
python -m venv venv
venv\Scripts\activate       # Windows
source venv/bin/activate    # Mac/Linux

# Install dependencies
pip install -r requirements.txt

# Apply migrations
python manage.py migrate

# Run development server
python manage.py runserver
```

*API available at `http://127.0.0.1:8000`*

---

### 3️⃣ Frontend Setup (Flutter)

```bash
cd frontend

# Fetch Flutter packages
flutter pub get

# Configure API URL in your Flutter config file:
# - Local Docker:    http://localhost:8000
# - Android Emulator: http://10.0.2.2:8000
# - Production VPS: http://YOUR_VPS_IP

# Run the app
flutter run
```

---

## 🌐 API Endpoints

| Method | Endpoint | Description | Auth |
|---|---|---|---|
| GET | `/health/` | Service health check | Public |
| POST | `/api/register/` | Register new user | Public |
| POST | `/api/login/` | Obtain JWT token | Public |
| POST | `/api/token/refresh/` | Refresh JWT token | Public |
| GET/POST | `/api/bookings/` | List / create bookings | Required |
| GET | `/api/bookings/available/` | Available loads for carriers 🔴 Cached | Required |
| GET | `/api/bookings/summary/` | Dashboard statistics 🔴 Cached | Required |
| GET | `/api/bookings/{id}/track/` | Real-time GPS tracking | Required |
| GET | `/api/bookings/{id}/bids/` | Bids on a specific load | Required |
| PATCH | `/api/bids/{id}/respond/` | Accept or decline a bid | Required |
| GET/POST | `/api/shipments/` | Manage shipments | Required |
| GET/POST | `/api/bids/` | Place / view bids | Required |
| POST | `/api/carrier/documents/` | Upload carrier documents | Required |

> 🔴 **Cached** — responses served from Redis for improved performance, auto-invalidated on data changes.

---

## ☸️ Kubernetes Deployment

```bash
# Apply all manifests in order
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/postgres-statefulset.yaml
kubectl apply -f k8s/redis-deployment.yaml
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/celery-deployment.yaml
kubectl apply -f k8s/ingress.yaml

# Wait for pods to be ready
kubectl get pods --watch

# Run database migrations
kubectl exec -it deployment/backend -- python manage.py migrate

# Verify deployment
kubectl get services
```

---

## 🤖 CI/CD Pipeline

This repository uses **GitHub Actions** to automate the mobile build process.

On every push to the `new_frontend` branch, the pipeline automatically:
1. Provisions an Ubuntu runner with Java 17
2. Installs the stable Flutter channel
3. Fetches all dependencies inside `frontend/`
4. Compiles a fresh `app-debug.apk`
5. Uploads the APK as a downloadable artifact in the GitHub Actions tab

---

## 🌐 Live Deployment

* **Backend API:** Deployed on VPS via Kubernetes
* **Container Image:** [`thedarkweb/cargolink-backend`](https://hub.docker.com/r/thedarkweb/cargolink-backend)
* **Health Check:** `http://YOUR_VPS_IP/health/`

---

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m 'feat: add some feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a Pull Request into `develop`

---

## 👨‍💻 Team

* **Emmanuel Kimbi** — Full Stack Developer
