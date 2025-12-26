from django.db import models # This is the correct way
from users.models import Shipper, Carrier, AdminProfile, User, Booking
from django.contrib.auth.models import AbstractUser

class ForeignKey:
    pass


class Carrier:
    pass



class Booking(models.Model):
    STATUS_CHOICES = (('Pending', 'Pending'), ('Accepted', 'Accepted'), ('Picked_Up', 'Picked_Up'),
                      ('In_Transit', 'In_Transit'), ('Delivered', 'Delivered'), ('Cancelled', 'Cancelled'))
    CARGO_TYPES = (('Documents', 'Documents'), ('Electronics', 'Electronics'), ('Furniture', 'Furniture'),
                   ('Food', 'Food'), ('Others', 'Others'))

    # Change these references to include 'users.'
    shipper = models.ForeignKey('users.Shipper', on_delete=models.CASCADE)
    carrier = models.ForeignKey('users.Carrier', on_delete=models.CASCADE, null=True, blank=True)
    pickup_location = models.CharField(max_length=255)
    pickup_latitude = models.FloatField()
    pickup_longitude = models.FloatField()
    dropoff_location = models.CharField(max_length=255)
    dropoff_latitude = models.FloatField()
    dropoff_longitude = models.FloatField()
    cargo_type = models.CharField(max_length=20, choices=CARGO_TYPES)
    cargo_weight_kg = models.FloatField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Pending')
    fare_amount = models.FloatField()
    created_at = models.DateTimeField(auto_now_add=True)


class LocationTracking(models.Model):
    # Putting 'Booking' in quotes solves the "invalid model" error
    booking = models.ForeignKey('Booking', on_delete=models.CASCADE)
    # Tell Django to look in the 'users' app for the Carrier model
    carrier = models.ForeignKey('users.Carrier', on_delete=models.CASCADE)
    latitude = models.FloatField()
    longitude = models.FloatField()
    timestamp = models.DateTimeField(auto_now_add=True)

class Dispute(models.Model):
        booking = models.ForeignKey(Booking, on_delete=models.CASCADE)
        raised_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='disputes_raised')
        dispute_status = models.CharField(max_length=20, default='Open')
        resolved_by = models.ForeignKey(AdminProfile, on_delete=models.SET_NULL, null=True)


def ratings():
    return None


def payments():
    return None


class Rating:
    pass


class Transaction:
    pass