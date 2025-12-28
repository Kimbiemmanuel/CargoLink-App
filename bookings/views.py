from rest_framework import viewsets, permissions
from .models import Booking
from .serializers import CargoSerializer

class CargoViewSet(viewsets.ModelViewSet):
    queryset = Booking.objects.all()
    serializer_class = CargoSerializer
    permission_classes = [permissions.IsAuthenticated]

    # This ensures that when a cargo is created,
    # the logged-in user is saved as the 'owner'.
    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)