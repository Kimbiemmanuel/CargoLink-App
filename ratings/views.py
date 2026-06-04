from rest_framework import viewsets, permissions
from .models import Rating
from .serializers import RatingSerializer


class RatingViewSet(viewsets.ModelViewSet):
    serializer_class = RatingSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Rating.objects.filter(from_user=self.request.user).select_related('booking', 'to_user')

    def perform_create(self, serializer):
        serializer.save(from_user=self.request.user)
