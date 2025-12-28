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
        # If the user is a 'Driver', show available cargo or their assignments
        if hasattr(user, 'role') and user.role == 'driver':
            return Booking.objects.filter(status__in=['available', 'assigned'])
        # If the user is a 'Sender', show only cargo they created
        return Booking.objects.filter(owner=user)

    @action(detail=True, methods=['post'])
    def accept_cargo(self, request, pk=None):
        """Custom action for drivers to accept a cargo job"""
        cargo = self.get_object()
        if cargo.status != 'available':
            return Response({'error': 'Cargo is no longer available'}, status=status.HTTP_400_BAD_REQUEST)

        cargo.driver = request.user
        cargo.status = 'assigned'
        cargo.save()
        return Response({'status': 'Cargo successfully assigned to you'})