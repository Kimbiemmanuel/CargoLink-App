from rest_framework import serializers

from .models import Booking, LocationTracking, Dispute


class CargoSerializer(serializers.ModelSerializer):
    shipper_email = serializers.ReadOnlyField(source='shipper.user.email')
    carrier_name = serializers.ReadOnlyField(source='carrier.full_name')

    class Meta:
        model = Booking
        fields = [
            'id', 'shipper', 'shipper_email', 'carrier', 'carrier_name',
            'pickup_location', 'pickup_latitude', 'pickup_longitude',
            'dropoff_location', 'dropoff_latitude', 'dropoff_longitude',
            'cargo_type', 'cargo_weight_kg', 'status', 'fare_amount',
            'created_at', 'updated_at',
        ]
        read_only_fields = ['id', 'shipper', 'status', 'created_at', 'updated_at']


class LocationTrackingSerializer(serializers.ModelSerializer):
    class Meta:
        model = LocationTracking
        fields = '__all__'


class DisputeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Dispute
        fields = '__all__'
        read_only_fields = ['raised_by', 'created_at']
