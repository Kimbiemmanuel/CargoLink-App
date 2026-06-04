from django.core.cache import cache
from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response

from .models import Booking
from .serializers import CargoSerializer


class CargoViewSet(viewsets.ModelViewSet):
    serializer_class = CargoSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        cache_key = f'bookings_user_{user.pk}'
        cached = cache.get(cache_key)
        if cached is not None:
            return cached

        if user.user_type == 'Carrier':
            qs = Booking.objects.filter(status__in=['Pending', 'Accepted']).select_related('shipper')
        elif user.user_type == 'Admin':
            qs = Booking.objects.all().select_related('shipper', 'carrier')
        else:
            qs = Booking.objects.filter(shipper__user=user).select_related('carrier')

        cache.set(cache_key, qs, timeout=60)
        return qs

    def perform_create(self, serializer):
        shipper = self.request.user.shipper
        serializer.save(shipper=shipper)

    @action(detail=True, methods=['post'])
    def accept(self, request, pk=None):
        booking = self.get_object()
        if booking.status != 'Pending':
            return Response({'error': 'Booking is no longer pending'}, status=status.HTTP_400_BAD_REQUEST)
        carrier = request.user.carrier
        booking.carrier = carrier
        booking.status = 'Accepted'
        booking.save()
        cache.delete(f'bookings_user_{request.user.pk}')
        return Response({'status': 'Booking accepted'})

    @action(detail=True, methods=['post'])
    def update_status(self, request, pk=None):
        booking = self.get_object()
        new_status = request.data.get('status')
        valid = [s[0] for s in Booking.STATUS_CHOICES]
        if new_status not in valid:
            return Response({'error': f'Invalid status. Choose from {valid}'}, status=status.HTTP_400_BAD_REQUEST)
        booking.status = new_status
        booking.save()
        cache.delete(f'bookings_user_{request.user.pk}')
        return Response({'status': new_status})
