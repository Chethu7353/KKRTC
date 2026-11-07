from django.urls import path

from apps.trips.views import ActiveTripsView, EndTripView, StartTripView

urlpatterns = [
    path('start/', StartTripView.as_view(), name='trip-start'),
    path('end/', EndTripView.as_view(), name='trip-end'),
    path('active/', ActiveTripsView.as_view(), name='active-trips'),
]
