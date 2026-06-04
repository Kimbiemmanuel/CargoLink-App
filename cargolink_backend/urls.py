from django.contrib import admin
from django.urls import path, include
from rest_framework.authtoken.views import obtain_auth_token
from rest_framework.routers import DefaultRouter

from bookings.views import CargoViewSet
from payments.views import TransactionViewSet
from ratings.views import RatingViewSet
from users.views import RegisterView

router = DefaultRouter()
router.register(r'bookings', CargoViewSet, basename='bookings')
router.register(r'transactions', TransactionViewSet, basename='transactions')
router.register(r'ratings', RatingViewSet, basename='ratings')

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/register/', RegisterView.as_view(), name='register'),
    path('api/login/', obtain_auth_token, name='api_token_auth'),
    path('api/', include(router.urls)),
]
