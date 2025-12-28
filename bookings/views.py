from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import Booking
from .serializers import CargoSerializer

class CargoViewSet(viewsets.ModelViewSet):
    queryset = Booking.objects.all()
    serializer_class = CargoSerializer
    permission_classes = [IsAuthenticated] # Only logged-in users can see cargo