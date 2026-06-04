from django.db import models

from bookings.models import Booking


class Transaction(models.Model):
    PAYMENT_STATUS = (
        ('Pending', 'Pending'),
        ('Completed', 'Completed'),
        ('Failed', 'Failed'),
        ('Refunded', 'Refunded'),
    )
    booking = models.OneToOneField(Booking, on_delete=models.CASCADE)
    amount = models.FloatField()
    net_earnings = models.FloatField()
    payment_status = models.CharField(max_length=20, choices=PAYMENT_STATUS, default='Pending')
    stripe_payment_intent_id = models.CharField(max_length=255, unique=True, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Transaction #{self.pk} — {self.payment_status}"
