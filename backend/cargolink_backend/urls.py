from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.http import JsonResponse
from django.db import connection
from django.core.cache import cache
from rest_framework_simplejwt.views import TokenRefreshView, TokenObtainPairView
from rest_framework.routers import DefaultRouter
from users.views import RegisterView, LoginView, CarrierDocumentUploadView
from bookings.views import BookingViewSet, ShipmentViewSet, BookingSummaryView, BidViewSet


# ── Health Check ──────────────────────────────────────────────
def health_check(request):
    checks = {}
    try:
        connection.ensure_connection()
        checks['database'] = 'ok'
    except Exception as e:
        checks['database'] = f'error: {str(e)}'
    try:
        cache.set('health_ping', 'pong', timeout=5)
        checks['cache'] = 'ok'
    except Exception as e:
        checks['cache'] = f'error: {str(e)}'

    status = 200 if all(v == 'ok' for v in checks.values()) else 503
    return JsonResponse({
        'status': 'healthy' if status == 200 else 'degraded',
        'checks': checks
    }, status=status)


# ── Router ────────────────────────────────────────────────────
router = DefaultRouter()
router.register(r'bookings', BookingViewSet, basename='booking')
router.register(r'shipments', ShipmentViewSet, basename='shipment')
router.register(r'bids', BidViewSet, basename='bid')

# ── URL Patterns ──────────────────────────────────────────────
urlpatterns = [
    path('health/', health_check, name='health_check'),
    path('admin/', admin.site.urls),
    path('api/bookings/summary/', BookingSummaryView.as_view(), name='booking-summary'),
    path('api/', include(router.urls)),
    path('api/register/', RegisterView.as_view(), name='register'),
    path('api/login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/carrier/documents/', CarrierDocumentUploadView.as_view(), name='carrier-document-upload'),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)