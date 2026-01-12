# Notifications Service
"""
Handles email, SMS, and push notifications
"""

from django.core.mail import send_mail
from django.conf import settings
import logging

logger = logging.getLogger(__name__)


class NotificationsService:
    """
    Service for sending notifications
    """

    @staticmethod
    def send_email(to_email, subject, message, html_message=None):
        """
        Send email notification
        """
        try:
            send_mail(
                subject,
                message,
                settings.DEFAULT_FROM_EMAIL,
                [to_email],
                html_message=html_message,
                fail_silently=False,
            )
            return {'success': True}
        except Exception as e:
            logger.error(f"Email sending error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def send_sms(phone_number, message):
        """
        Send SMS notification (integrate with Twilio/Vonage)
        """
        try:
            # TODO: Integrate with SMS provider
            logger.info(f"SMS sent to {phone_number}: {message}")
            return {'success': True}
        except Exception as e:
            logger.error(f"SMS sending error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def send_push_notification(user, title, message, data=None):
        """
        Send push notification (Firebase Cloud Messaging)
        """
        try:
            # TODO: Integrate with FCM
            logger.info(f"Push notification sent to {user.email}: {title}")
            return {'success': True}
        except Exception as e:
            logger.error(f"Push notification error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def notify_booking_accepted(booking):
        """
        Notify shipper that booking was accepted
        """
        subject = "Your booking has been accepted!"
        message = f"Booking #{booking.id} has been accepted by a carrier."
        return NotificationsService.send_email(
            booking.shipper.user.email,
            subject,
            message
        )

    @staticmethod
    def notify_booking_delivered(booking):
        """
        Notify shipper that booking was delivered
        """
        subject = "Your delivery is complete!"
        message = f"Booking #{booking.id} has been successfully delivered."
        return NotificationsService.send_email(
            booking.shipper.user.email,
            subject,
            message
        )

    @staticmethod
    def notify_carrier_new_booking(booking):
        """
        Notify carrier about new available booking
        """
        subject = "New booking available!"
        message = f"A new {booking.cargo_type} booking is available for {booking.cargo_weight_kg}kg"
        
        # Notify all available carriers
        # TODO: Implement carrier filtering
        return {'success': True}
