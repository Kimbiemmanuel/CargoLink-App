# Admin Service
"""
Handles admin operations like user verification, dispute resolution, and reporting
"""

from users.models import User, Carrier, AdminProfile
from bookings.models import Booking, Dispute
from ratings.models import Rating
from django.db.models import Count, Avg, Sum
from django.utils import timezone
import logging

logger = logging.getLogger(__name__)


class AdminService:
    """
    Service for admin operations
    """

    @staticmethod
    def get_dashboard_stats():
        """
        Get system-wide statistics
        """
        try:
            return {
                'success': True,
                'stats': {
                    'total_users': User.objects.count(),
                    'total_shippers': User.objects.filter(user_type='Shipper').count(),
                    'total_carriers': User.objects.filter(user_type='Carrier').count(),
                    'total_admins': User.objects.filter(user_type='Admin').count(),
                    'total_bookings': Booking.objects.count(),
                    'completed_bookings': Booking.objects.filter(status='Delivered').count(),
                    'active_bookings': Booking.objects.filter(
                        status__in=['Pending', 'Accepted', 'In_Transit', 'Picked_Up']
                    ).count(),
                    'pending_disputes': Dispute.objects.filter(dispute_status='Open').count(),
                    'total_revenue': sum(
                        [b.fare_amount for b in Booking.objects.filter(status='Delivered')]
                    )
                }
            }
        except Exception as e:
            logger.error(f"Dashboard stats error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def verify_carrier(carrier_id):
        """
        Verify a carrier account
        """
        try:
            carrier = Carrier.objects.get(id=carrier_id)
            carrier.is_verified = True
            carrier.save()
            return {'success': True, 'message': 'Carrier verified'}
        except Carrier.DoesNotExist:
            return {'success': False, 'error': 'Carrier not found'}
        except Exception as e:
            logger.error(f"Carrier verification error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def suspend_user(user_id, reason):
        """
        Suspend a user account
        """
        try:
            user = User.objects.get(id=user_id)
            user.is_active = False
            user.save()
            
            logger.info(f"User {user_id} suspended. Reason: {reason}")
            return {'success': True, 'message': 'User suspended'}
        except User.DoesNotExist:
            return {'success': False, 'error': 'User not found'}
        except Exception as e:
            logger.error(f"User suspension error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def unsuspend_user(user_id):
        """
        Reactivate a suspended user
        """
        try:
            user = User.objects.get(id=user_id)
            user.is_active = True
            user.save()
            return {'success': True, 'message': 'User reactivated'}
        except User.DoesNotExist:
            return {'success': False, 'error': 'User not found'}
        except Exception as e:
            logger.error(f"User reactivation error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def resolve_dispute(dispute_id, resolution, notes):
        """
        Resolve a dispute
        """
        try:
            dispute = Dispute.objects.get(id=dispute_id)
            dispute.dispute_status = 'Resolved'
            dispute.resolved_by = AdminProfile.objects.first()  # Current admin
            dispute.save()
            
            logger.info(f"Dispute {dispute_id} resolved. Resolution: {resolution}")
            return {'success': True, 'message': 'Dispute resolved'}
        except Dispute.DoesNotExist:
            return {'success': False, 'error': 'Dispute not found'}
        except Exception as e:
            logger.error(f"Dispute resolution error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def get_reports(report_type='general', date_from=None, date_to=None):
        """
        Generate system reports
        """
        try:
            if report_type == 'users':
                return {
                    'success': True,
                    'data': {
                        'by_type': {
                            'shippers': User.objects.filter(user_type='Shipper').count(),
                            'carriers': User.objects.filter(user_type='Carrier').count(),
                            'admins': User.objects.filter(user_type='Admin').count(),
                        },
                        'verified_carriers': Carrier.objects.filter(is_verified=True).count(),
                        'active_users': User.objects.filter(is_active=True).count(),
                    }
                }
            elif report_type == 'bookings':
                return {
                    'success': True,
                    'data': {
                        'total': Booking.objects.count(),
                        'by_status': dict(
                            Booking.objects.values('status').annotate(count=Count('id')).values_list('status', 'count')
                        ),
                        'total_value': sum([b.fare_amount for b in Booking.objects.all()])
                    }
                }
            else:
                return AdminService.get_dashboard_stats()
        except Exception as e:
            logger.error(f"Report generation error: {str(e)}")
            return {'success': False, 'error': str(e)}
