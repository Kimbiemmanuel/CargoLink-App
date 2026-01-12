# Tracking Service
"""
Handles real-time location tracking and history
"""

from bookings.models import Booking, LocationTracking
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
import logging

logger = logging.getLogger(__name__)


class TrackingService:
    """
    Service for handling booking tracking
    """

    @staticmethod
    def update_location(booking_id, latitude, longitude, carrier=None):
        """
        Update booking location and broadcast to connected clients
        
        Args:
            booking_id: ID of the booking
            latitude: Current latitude
            longitude: Current longitude
            carrier: Carrier instance (optional)
            
        Returns:
            dict: Update status
        """
        try:
            booking = Booking.objects.get(id=booking_id)
            
            # Save location tracking record
            location = LocationTracking.objects.create(
                booking=booking,
                carrier=booking.carrier,
                latitude=latitude,
                longitude=longitude
            )
            
            # Broadcast to WebSocket consumers
            channel_layer = get_channel_layer()
            async_to_sync(channel_layer.group_send)(
                f'booking_{booking_id}',
                {
                    'type': 'location_update',
                    'latitude': latitude,
                    'longitude': longitude,
                    'timestamp': location.timestamp.isoformat()
                }
            )
            
            return {
                'success': True,
                'location_id': location.id,
                'timestamp': location.timestamp.isoformat()
            }
        except Booking.DoesNotExist:
            return {'success': False, 'error': 'Booking not found'}
        except Exception as e:
            logger.error(f"Location update error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def get_current_location(booking_id):
        """
        Get the most recent location for a booking
        """
        try:
            location = LocationTracking.objects.filter(
                booking_id=booking_id
            ).latest('timestamp')
            
            return {
                'success': True,
                'latitude': location.latitude,
                'longitude': location.longitude,
                'timestamp': location.timestamp.isoformat()
            }
        except LocationTracking.DoesNotExist:
            return {'success': False, 'error': 'No location data available'}
        except Exception as e:
            logger.error(f"Get location error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def get_location_history(booking_id, limit=50):
        """
        Get location history for a booking
        """
        try:
            locations = LocationTracking.objects.filter(
                booking_id=booking_id
            ).order_by('timestamp')[:limit]
            
            return {
                'success': True,
                'locations': [
                    {
                        'latitude': loc.latitude,
                        'longitude': loc.longitude,
                        'timestamp': loc.timestamp.isoformat()
                    }
                    for loc in locations
                ]
            }
        except Exception as e:
            logger.error(f"Location history error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def calculate_distance(lat1, lon1, lat2, lon2):
        """
        Calculate distance between two coordinates using Haversine formula
        Returns distance in kilometers
        """
        from math import radians, cos, sin, asin, sqrt
        
        lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])
        dlon = lon2 - lon1
        dlat = lat2 - lat1
        a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
        c = 2 * asin(sqrt(a))
        r = 6371  # Radius of earth in kilometers
        return c * r
