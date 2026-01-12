# Authentication Service
"""
Handles user authentication, registration, and Firebase integration
"""

from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from firebase_admin import auth as firebase_auth
from users.models import User, Shipper, Carrier, AdminProfile
import logging

logger = logging.getLogger(__name__)


class AuthenticationService:
    """
    Centralized authentication service for handling user auth
    """

    @staticmethod
    def register_user(email, password, phone, user_type, first_name='', last_name=''):
        """
        Register a new user with Firebase and Django
        
        Args:
            email: User email
            password: User password
            phone: User phone number
            user_type: 'Shipper', 'Carrier', or 'Admin'
            first_name: Optional first name
            last_name: Optional last name
            
        Returns:
            dict: User data and token
        """
        try:
            # Create Firebase user
            firebase_user = firebase_auth.create_user(
                email=email,
                password=password
            )
            
            # Create Django user
            user = User.objects.create_user(
                email=email,
                password=password,
                phone=phone,
                user_type=user_type,
                first_name=first_name,
                last_name=last_name,
            )
            
            # Create role-specific profile
            if user_type == 'Shipper':
                Shipper.objects.create(
                    user=user,
                    full_name=f"{first_name} {last_name}".strip()
                )
            elif user_type == 'Carrier':
                Carrier.objects.create(
                    user=user,
                    full_name=f"{first_name} {last_name}".strip()
                )
            elif user_type == 'Admin':
                AdminProfile.objects.create(
                    user=user,
                    admin_name=f"{first_name} {last_name}".strip()
                )
            
            # Generate token
            token, _ = Token.objects.get_or_create(user=user)
            
            return {
                'success': True,
                'firebase_uid': firebase_user.uid,
                'token': token.key,
                'user': {
                    'id': user.id,
                    'email': user.email,
                    'user_type': user.user_type
                }
            }
        except Exception as e:
            logger.error(f"Registration error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def verify_firebase_token(id_token):
        """
        Verify Firebase ID token
        
        Args:
            id_token: Firebase ID token from client
            
        Returns:
            dict: Decoded token claims or error
        """
        try:
            decoded_token = firebase_auth.verify_id_token(id_token)
            return {'success': True, 'claims': decoded_token}
        except Exception as e:
            logger.error(f"Token verification error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def login_user(email, password):
        """
        Authenticate user with email and password
        
        Args:
            email: User email
            password: User password
            
        Returns:
            dict: User data and token
        """
        try:
            user = User.objects.get(email=email)
            if user.check_password(password):
                token, _ = Token.objects.get_or_create(user=user)
                return {
                    'success': True,
                    'token': token.key,
                    'user': {
                        'id': user.id,
                        'email': user.email,
                        'user_type': user.user_type,
                        'is_email_verified': user.is_email_verified
                    }
                }
            return {'success': False, 'error': 'Invalid credentials'}
        except User.DoesNotExist:
            return {'success': False, 'error': 'User not found'}
        except Exception as e:
            logger.error(f"Login error: {str(e)}")
            return {'success': False, 'error': str(e)}

    @staticmethod
    def logout_user(user):
        """
        Logout user by deleting token
        """
        try:
            Token.objects.filter(user=user).delete()
            return {'success': True}
        except Exception as e:
            return {'success': False, 'error': str(e)}

    @staticmethod
    def reset_password(email):
        """
        Send password reset email via Firebase
        """
        try:
            firebase_auth.generate_password_reset_link(email)
            return {'success': True, 'message': 'Password reset email sent'}
        except Exception as e:
            logger.error(f"Password reset error: {str(e)}")
            return {'success': False, 'error': str(e)}
