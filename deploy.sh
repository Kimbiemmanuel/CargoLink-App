#!/bin/bash
# ============================================================
# CargoLink VPS Deployment Script
# Run this ON the VPS after SSH-ing in
# Usage: bash deploy.sh
# ============================================================

set -e  # Exit on any error

echo "========================================"
echo "  CargoLink Deployment Script"
echo "========================================"

# ── 1. Install Docker & Docker Compose ──────────────────────
if ! command -v docker &> /dev/null; then
  echo "[1/6] Installing Docker..."
  apt-get update -y
  apt-get install -y ca-certificates curl gnupg
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    > /etc/apt/sources.list.d/docker.list
  apt-get update -y
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  systemctl enable docker
  systemctl start docker
  echo "[1/6] ✅ Docker installed"
else
  echo "[1/6] ✅ Docker already installed"
fi

# ── 2. Install Git ───────────────────────────────────────────
if ! command -v git &> /dev/null; then
  echo "[2/6] Installing Git..."
  apt-get install -y git
fi
echo "[2/6] ✅ Git ready"

# ── 3. Clone / Update repo ──────────────────────────────────
REPO_DIR="/opt/cargolink"
if [ -d "$REPO_DIR/.git" ]; then
  echo "[3/6] Pulling latest code..."
  cd "$REPO_DIR"
  git pull origin main
else
  echo "[3/6] Cloning repository..."
  # Replace with your actual GitHub repo URL
  git clone https://github.com/YOUR_USERNAME/Cargo-link.git "$REPO_DIR"
  cd "$REPO_DIR"
fi
echo "[3/6] ✅ Code up to date"

# ── 4. Set up .env ───────────────────────────────────────────
echo "[4/6] Checking .env..."
if [ ! -f "$REPO_DIR/.env" ]; then
  cp "$REPO_DIR/.env.production" "$REPO_DIR/.env"
  echo ""
  echo "  ⚠️  IMPORTANT: Edit /opt/cargolink/.env and set a real SECRET_KEY!"
  echo "  Run: nano /opt/cargolink/.env"
  echo "  Then re-run this script."
  echo ""
  # Generate a random secret key automatically
  SECRET=$(python3 -c "import secrets; print(secrets.token_urlsafe(50))")
  sed -i "s/CHANGE_THIS_TO_A_LONG_RANDOM_STRING_50_CHARS/$SECRET/" "$REPO_DIR/.env"
  echo "[4/6] ✅ .env created with auto-generated SECRET_KEY"
else
  echo "[4/6] ✅ .env already exists"
fi

# ── 5. Build & Start containers ─────────────────────────────
echo "[5/6] Building and starting containers..."
cd "$REPO_DIR"
docker compose down --remove-orphans 2>/dev/null || true
docker compose pull db redis nginx 2>/dev/null || true
docker compose build backend
docker compose up -d
echo "[5/6] ✅ Containers started"

# ── 6. Create superuser (first deploy only) ─────────────────
echo "[6/6] Waiting for backend to be ready..."
sleep 10
docker compose exec -T backend python manage.py migrate --noinput

# Check if superuser exists, create if not
docker compose exec -T backend python manage.py shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(email='admin@cargolink.com').exists():
    User.objects.create_superuser(
        username='admin',
        email='admin@cargolink.com',
        password='Admin@1234!',
        user_type='admin'
    )
    print('Superuser created: admin@cargolink.com / Admin@1234!')
else:
    print('Superuser already exists')
" 2>/dev/null || echo "Superuser creation skipped (may already exist)"

echo ""
echo "========================================"
echo "  ✅ CargoLink deployed successfully!"
echo "========================================"
echo ""
echo "  Backend API: http://$(curl -s ifconfig.me)/api/"
echo "  Admin panel: http://$(curl -s ifconfig.me)/admin/"
echo "  Admin login: admin@cargolink.com / Admin@1234!"
echo ""
echo "  To view logs:     docker compose logs -f backend"
echo "  To stop:          docker compose down"
echo "  To restart:       docker compose restart"
echo ""
