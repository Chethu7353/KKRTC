from rest_framework import serializers

from apps.buses.models import Bus
from apps.routes.models import Route
from apps.trips.models import Trip


class StartTripSerializer(serializers.Serializer):
    route_id = serializers.PrimaryKeyRelatedField(
        source='route', queryset=Route.objects.filter(is_active=True)
    )
    bus_id = serializers.PrimaryKeyRelatedField(
        source='bus', queryset=Bus.objects.filter(is_active=True)
    )

    def validate(self, attrs):
        pilot = self.context['request'].user
        if attrs['bus'].pilot_id != pilot.id:
            raise serializers.ValidationError(
                {'bus_id': 'This bus is not assigned to the authenticated pilot.'}
            )
        return attrs


class EndTripSerializer(serializers.Serializer):
    trip_id = serializers.IntegerField(min_value=1)


class ActiveTripSerializer(serializers.ModelSerializer):
    route = serializers.SerializerMethodField()

    class Meta:
        model = Trip
        fields = ('id', 'route', 'status', 'start_time')

    def get_route(self, trip):
        return str(trip.route)
