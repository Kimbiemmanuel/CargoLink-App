from rest_framework import serializers
from .models import Booking  # Replace with your actual model name

class CargoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Booking
        fields = '__all__'  # Or list specific fields like ['id', 'weight', 'origin']