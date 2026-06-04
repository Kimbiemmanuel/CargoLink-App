from django.core.validators import MinValueValidator, MaxValueValidator
from django.db import models

from bookings.models import Booking


class Rating(models.Model):
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE)
    from_user = models.ForeignKey(
        'users.User', on_delete=models.CASCADE, related_name='ratings_given'
    )
    to_user = models.ForeignKey(
        'users.User', on_delete=models.CASCADE, related_name='ratings_received'
    )
    score = models.IntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    review_text = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('booking', 'from_user')
