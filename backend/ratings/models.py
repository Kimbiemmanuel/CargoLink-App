from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from django.conf import settings
from bookings.models import Booking


class Rating(models.Model):
    booking = models.ForeignKey(
        Booking, on_delete=models.CASCADE, related_name='ratings'
    )
    from_user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='ratings_given'
    )
    to_user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='ratings_received'
    )
    score = models.IntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(5)]
    )
    review_text = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Rating {self.score}/5 from {self.from_user} to {self.to_user}"