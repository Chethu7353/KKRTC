from channels.db import database_sync_to_async
from channels.generic.websocket import AsyncJsonWebsocketConsumer

from apps.trips.models import Trip


class ActiveTripsConsumer(AsyncJsonWebsocketConsumer):
    async def connect(self):
        await self.channel_layer.group_add('active_trips', self.channel_name)
        await self.accept()
        await self.send_json(
            {
                'event': 'active_trips',
                'trips': await self.get_active_trips(),
            }
        )

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard('active_trips', self.channel_name)

    async def trip_started(self, event):
        await self.send_json(
            {
                'event': event['event'],
                'trip_id': event['trip_id'],
                'route': event['route'],
                'status': event['status'],
            }
        )

    async def trip_ended(self, event):
        await self.send_json(
            {
                'event': event['event'],
                'trip_id': event['trip_id'],
                'status': event['status'],
            }
        )

    @database_sync_to_async
    def get_active_trips(self):
        trips = Trip.objects.filter(status=Trip.Status.ACTIVE).select_related('route')
        return [
            {
                'trip_id': trip.id,
                'route': str(trip.route),
                'status': trip.status,
            }
            for trip in trips
        ]
