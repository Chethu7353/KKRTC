from django.urls import path

from apps.trips.consumers import ActiveTripsConsumer

websocket_urlpatterns = [
    path('ws/active-trips/', ActiveTripsConsumer.as_asgi()),
]
