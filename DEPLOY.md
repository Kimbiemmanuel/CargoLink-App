# CargoLink — VPS Deployment Guide (K3s + Kubernetes)

## Prerequisites
- A VPS with Ubuntu 22.04 (minimum 2 vCPU, 4GB RAM recommended)
- SSH access to the VPS
- Docker installed locally (to build and push the image)

---

## Step 1 — Build & Push Docker Image

```bash
# On your local machine, from the project root:

# Option A: Push to Docker Hub
docker build -t YOUR_DOCKERHUB_USERNAME/cargolink-backend:latest .
docker push YOUR_DOCKERHUB_USERNAME/cargolink-backend:latest
```

Then update `k8s/backend.yaml` — change:
```yaml
image: cargolink-backend:latest
```
to:
```yaml
image: YOUR_DOCKERHUB_USERNAME/cargolink-backend:latest
imagePullPolicy: Always
```

---

## Step 2 — Provision the VPS

```bash
# SSH into your VPS
ssh root@YOUR_VPS_IP

# Update system
apt update && apt upgrade -y

# Install K3s (lightweight Kubernetes — single command)
curl -sfL https://get.k3s.io | sh -

# Verify K3s is running
kubectl get nodes
# Should show:  NAME   STATUS   ROLES                  AGE
#               vps    Ready    control-plane,master   1m

# Copy kubeconfig so kubectl works without sudo
mkdir -p ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
chmod 600 ~/.kube/config
```

---

## Step 3 — Copy K8s Manifests to VPS

```bash
# On your local machine:
scp -r k8s/ root@YOUR_VPS_IP:/root/cargolink-k8s/
```

---

## Step 4 — Edit Secrets (on the VPS)

```bash
# On the VPS:
cd /root/cargolink-k8s
nano secrets.yaml
# Replace all REPLACE_ME values with real secrets
```

---

## Step 5 — Apply All Manifests

```bash
# On the VPS, apply in order:
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f secrets.yaml
kubectl apply -f postgres.yaml
kubectl apply -f redis.yaml
kubectl apply -f backend.yaml

# Watch everything come up:
kubectl get pods -n cargolink -w
```

Expected output after ~60s:
```
NAME                                  READY   STATUS    RESTARTS
cargolink-backend-xxxxxxxxx-xxxxx     1/1     Running   0
cargolink-backend-xxxxxxxxx-yyyyy     1/1     Running   0
postgres-xxxxxxxxx-xxxxx              1/1     Running   0
redis-xxxxxxxxx-xxxxx                 1/1     Running   0
nginx-xxxxxxxxx-xxxxx                 1/1     Running   0
```

---

## Step 6 — Access the Application

The app is exposed on port 30080 via the nginx NodePort service.

```bash
# Test from the VPS:
curl http://localhost:30080/api/

# From your browser:
http://YOUR_VPS_IP:30080/api/
http://YOUR_VPS_IP:30080/admin/
```

---

## Step 7 — (Optional) Point a Domain + Enable HTTPS

```bash
# Install cert-manager for free TLS via Let's Encrypt
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml

# Then create an Ingress with TLS — update k8s/backend.yaml to add an Ingress resource
```

---

## Useful Commands

```bash
# View logs of the Django backend
kubectl logs -n cargolink -l app=cargolink-backend --tail=50

# Scale to 3 replicas (load balancing demo)
kubectl scale deployment cargolink-backend -n cargolink --replicas=3

# Run Django management commands inside a pod
kubectl exec -n cargolink -it deployment/cargolink-backend -- python manage.py createsuperuser

# View all services
kubectl get services -n cargolink

# Describe a failing pod
kubectl describe pod -n cargolink POD_NAME
```

---

## Architecture Diagram

```
Internet
    │
    ▼
[VPS :30080]
    │
[nginx Service - NodePort]
    │
[nginx Pod] ──────────────────────────────────┐
    │                                          │
    │ /api/*  /admin/*  /ws/*                  │ /static/*  /media/*
    ▼                                          ▼
[backend-service ClusterIP]            [Static Files Volume]
    │
    │ (Load Balanced across 2 pods)
    ├──► [Django Pod 1]
    └──► [Django Pod 2]
              │
    ┌─────────┴──────────┐
    ▼                    ▼
[postgres-service]   [redis-service]
[PostgreSQL Pod]     [Redis Pod]
[PersistentVolume]
```
