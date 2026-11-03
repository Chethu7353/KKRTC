"""
URL configuration for KKRTC - Where Is My Bus?
"""
from django.contrib import admin
from django.urls import path
from django.http import JsonResponse

def health_check(request):
    return JsonResponse({
        "status": "healthy",
        "service": "KKRTC - Where Is My Bus? API",
        "version": "1.0.0",
        "database": "connected"
    })

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/health/', health_check, name='api-health'),
]
