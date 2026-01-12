# Payments Service
"""
Handles payment processing, transactions, and stripe integration
"""

import stripe
from decimal import Decimal
from django.conf import settings
from bookings.models import Booking
from payments.models import Transaction
from users.models import Carrier
import logging

logger = logging.getLogger(__name__)

stripe.api_key = settings.STRIPE_SECRET_KEY


class PaymentsService:
    """
    Service for handling payments and transactions
    """

    @staticmethod
    def create_payment_intent(booking_id, amount):
        """
        Create a Stripe payment intent
        
        Args:
            booking_id: ID of the booking
            amount: Amount in cents
            
        Returns:
            dict: Payment intent details
        """
        try:
            booking = Booking.objects.get(id=booking_id)
            
            intent = stripe.PaymentIntent.create(
                amount=int(amount * 100),  # Convert to cents
                currency='xaf',  # Cameroon currency
                metadata={'booking_id': booking_id}
            )
            
            transaction = Transaction.objects.create(
                booking=booking,
                amount=amount,
                stripe_payment_intent_id=intent.id,
                payment_status='Pending'
            )
            
            return {
                'success': True,
                'client_secret': intent.client_secret,
                'payment_intent_id': intent.id,
                'transaction_id': transaction.id
            }
        except Exception as e:
            logger.error(f"Payment intent creation error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def confirm_payment(payment_intent_id):
        """
        Confirm payment and update transaction status
        
        Args:
            payment_intent_id: Stripe payment intent ID
            
        Returns:
            dict: Payment confirmation status
        """
        try:
            intent = stripe.PaymentIntent.retrieve(payment_intent_id)
            
            if intent.status == 'succeeded':
                transaction = Transaction.objects.get(
                    stripe_payment_intent_id=payment_intent_id
                )
                transaction.payment_status = 'Completed'
                transaction.save()
                
                # Update carrier earnings
                booking = transaction.booking
                if booking.carrier:
                    carrier = Carrier.objects.get(user=booking.carrier.user)
                    carrier.total_earnings += Decimal(transaction.net_earnings)
                    carrier.save()
                
                return {'success': True, 'status': 'completed'}
            
            return {'success': False, 'error': 'Payment not confirmed'}
        except Exception as e:
            logger.error(f"Payment confirmation error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def get_transaction_history(user, limit=20, offset=0):
        """
        Get transaction history for a user
        """
        try:
            transactions = Transaction.objects.filter(
                booking__shipper__user=user
            ).order_by('-created_at')[offset:offset+limit]
            
            return {
                'success': True,
                'transactions': [
                    {
                        'id': t.id,
                        'booking_id': t.booking.id,
                        'amount': float(t.amount),
                        'status': t.payment_status,
                        'created_at': t.created_at.isoformat()
                    }
                    for t in transactions
                ]
            }
        except Exception as e:
            logger.error(f"Transaction history error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def process_refund(transaction_id, reason=''):
        """
        Process refund for a transaction
        """
        try:
            transaction = Transaction.objects.get(id=transaction_id)
            
            refund = stripe.Refund.create(
                payment_intent=transaction.stripe_payment_intent_id,
                reason='requested_by_customer' if not reason else reason
            )
            
            transaction.payment_status = 'Refunded'
            transaction.save()
            
            return {
                'success': True,
                'refund_id': refund.id,
                'status': 'refunded'
            }
        except Exception as e:
            logger.error(f"Refund processing error: {str(e)}")
            return {'success': False, 'error': str(e)}
