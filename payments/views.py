from rest_framework import viewsets, permissions
from .models import Transaction
from .serializers import TransactionSerializer


class TransactionViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = TransactionSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.user_type == 'Admin':
            return Transaction.objects.all().select_related('booking')
        elif user.user_type == 'Carrier':
            return Transaction.objects.filter(booking__carrier__user=user).select_related('booking')
        return Transaction.objects.filter(booking__shipper__user=user).select_related('booking')
