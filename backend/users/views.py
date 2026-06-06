from django.contrib.auth import authenticate, get_user_model
from django.db import transaction
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework_simplejwt.tokens import RefreshToken
from .models import Shipper, Carrier, AdminProfile
from .serializers import UserSerializer, CarrierDocumentSerializer

User = get_user_model()


def ensure_user_profile(user):
    if not user.user_type:
        user.user_type = "Shipper"
        user.save(update_fields=["user_type"])
    if user.user_type == "Shipper":
        Shipper.objects.get_or_create(
            user=user,
            defaults={"full_name": user.username},
        )
    elif user.user_type == "Carrier":
        Carrier.objects.get_or_create(
            user=user,
            defaults={
                "full_name": user.username,
                "license_number": f"LIC-{user.username}-{user.pk}",
            },
        )
    elif user.user_type == "Admin":
        AdminProfile.objects.get_or_create(
            user=user,
            defaults={"admin_name": user.username, "role": "Support"},
        )


class RegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        user_type = request.data.get("user_type", "Shipper")
        valid_user_types = {choice[0] for choice in User.USER_TYPES}
        if user_type not in valid_user_types:
            return Response(
                {"error": f"user_type must be one of: {', '.join(valid_user_types)}"},
                status=status.HTTP_400_BAD_REQUEST,
            )
        serializer = UserSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({"errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
        with transaction.atomic():
            user = serializer.save(user_type=user_type)
            ensure_user_profile(user)
        refresh = RefreshToken.for_user(user)
        access_token = str(refresh.access_token)
        return Response(
            {
                "message": "Account created successfully.",
                "refresh": str(refresh),
                "access": access_token,
                "token": access_token,
                "username": user.username,
                "user_id": user.pk,
                "user": {
                    "username": user.username,
                    "email": user.email,
                    "country_code": user.country_code,
                    "phone": user.phone,
                    "full_phone": user.full_phone(),
                    "user_type": user.user_type,
                },
            },
            status=status.HTTP_201_CREATED,
        )


class LoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        username = request.data.get("username")
        email = request.data.get("email")
        identifier = request.data.get("identifier")
        password = request.data.get("password")
        login_value = username or email or identifier
        if not login_value or not password:
            return Response(
                {"error": "Username/email and password are required."},
                status=status.HTTP_400_BAD_REQUEST,
            )
        auth_username = login_value
        if "@" in login_value:
            matched_user = User.objects.filter(email__iexact=login_value).only("username").first()
            if matched_user:
                auth_username = matched_user.username
        user = authenticate(username=auth_username, password=password)
        if user:
            ensure_user_profile(user)
            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)
            return Response(
                {
                    "refresh": str(refresh),
                    "access": access_token,
                    "token": access_token,
                    "user_id": user.pk,
                    "username": user.username,
                    "user_type": user.user_type,
                },
                status=status.HTTP_200_OK,
            )
        return Response(
            {"error": "Invalid credentials. Please check your username/email and password."},
            status=status.HTTP_401_UNAUTHORIZED,
        )


class CarrierDocumentUploadView(APIView):
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]

    def get(self, request):
        if request.user.user_type != "Carrier":
            return Response(
                {"error": "Only carriers can access carrier document uploads."},
                status=status.HTTP_403_FORBIDDEN,
            )
        carrier, _ = Carrier.objects.get_or_create(
            user=request.user,
            defaults={
                "full_name": request.user.username,
                "license_number": f"LIC-{request.user.username}-{request.user.pk}",
            },
        )
        serializer = CarrierDocumentSerializer(carrier, context={"request": request})
        return Response(serializer.data, status=status.HTTP_200_OK)

    def patch(self, request):
        if request.user.user_type != "Carrier":
            return Response(
                {"error": "Only carriers can upload carrier documents."},
                status=status.HTTP_403_FORBIDDEN,
            )
        carrier, _ = Carrier.objects.get_or_create(
            user=request.user,
            defaults={
                "full_name": request.user.username,
                "license_number": f"LIC-{request.user.username}-{request.user.pk}",
            },
        )
        serializer = CarrierDocumentSerializer(
            carrier, data=request.data, partial=True, context={"request": request}
        )
        if serializer.is_valid():
            serializer.save()
            return Response(
                {"message": "Carrier documents uploaded successfully.", "documents": serializer.data},
                status=status.HTTP_200_OK,
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
