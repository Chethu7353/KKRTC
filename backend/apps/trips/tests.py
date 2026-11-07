from asgiref.sync import async_to_sync, sync_to_async
from channels.testing import WebsocketCommunicator
from django.contrib.auth import get_user_model
from django.test import TestCase, TransactionTestCase
from rest_framework.test import APIClient

from apps.accounts.models import UserProfile
from apps.buses.models import Bus
from apps.routes.models import Route
from apps.trips.models import Trip
from config.asgi import application


class StartTripApiTests(TestCase):
    def setUp(self):
        user_model = get_user_model()
        self.pilot = user_model.objects.create_user(username='pilot')
        UserProfile.objects.create(user=self.pilot, role=UserProfile.Role.PILOT)
        self.passenger = user_model.objects.create_user(username='passenger')
        UserProfile.objects.create(
            user=self.passenger, role=UserProfile.Role.PASSENGER
        )
        self.bus = Bus.objects.create(
            registration_number='KA-34-A-1001', pilot=self.pilot
        )
        self.route = Route.objects.create(
            source_name='Ballari', destination_name='Kampli'
        )
        self.client = APIClient()

    def test_authenticated_pilot_starts_trip_and_gets_contract(self):
        self.client.force_authenticate(self.pilot)

        response = self.client.post(
            '/api/trips/start/',
            {'route_id': self.route.id, 'bus_id': self.bus.id},
            format='json',
        )

        self.assertEqual(response.status_code, 201)
        trip = Trip.objects.get(pk=response.data['trip_id'])
        self.assertEqual(trip.status, Trip.Status.ACTIVE)
        self.assertEqual(trip.pilot, self.pilot)
        self.assertEqual(trip.bus, self.bus)
        self.assertEqual(trip.route, self.route)
        self.assertIsNotNone(trip.start_time)
        self.assertEqual(response.data['route'], 'Ballari - Kampli')
        self.assertEqual(response.data['status'], 'ACTIVE')
        self.assertIn('start_time', response.data)

    def test_passenger_cannot_start_trip(self):
        self.client.force_authenticate(self.passenger)
        response = self.client.post(
            '/api/trips/start/',
            {'route_id': self.route.id, 'bus_id': self.bus.id},
            format='json',
        )
        self.assertEqual(response.status_code, 403)
        self.assertFalse(Trip.objects.exists())

    def test_anonymous_user_cannot_start_trip(self):
        response = self.client.post(
            '/api/trips/start/',
            {'route_id': self.route.id, 'bus_id': self.bus.id},
            format='json',
        )
        self.assertEqual(response.status_code, 401)

    def test_pilot_cannot_start_another_active_trip(self):
        Trip.objects.create(pilot=self.pilot, bus=self.bus, route=self.route)
        self.client.force_authenticate(self.pilot)
        response = self.client.post(
            '/api/trips/start/',
            {'route_id': self.route.id, 'bus_id': self.bus.id},
            format='json',
        )
        self.assertEqual(response.status_code, 400)
        self.assertEqual(Trip.objects.filter(pilot=self.pilot).count(), 1)

    def test_pilot_cannot_start_trip_using_another_pilots_bus(self):
        other_pilot = get_user_model().objects.create_user(username='other-pilot')
        UserProfile.objects.create(user=other_pilot, role=UserProfile.Role.PILOT)
        other_bus = Bus.objects.create(
            registration_number='KA-34-A-2002', pilot=other_pilot
        )
        self.client.force_authenticate(self.pilot)
        response = self.client.post(
            '/api/trips/start/',
            {'route_id': self.route.id, 'bus_id': other_bus.id},
            format='json',
        )
        self.assertEqual(response.status_code, 400)
        self.assertFalse(Trip.objects.exists())

    def test_active_trips_endpoint_returns_empty_when_no_trip_exists(self):
        self.client.force_authenticate(self.passenger)
        response = self.client.get('/api/trips/active/')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data, [])

    def test_starting_pilot_can_end_trip_and_history_is_retained(self):
        trip = Trip.objects.create(pilot=self.pilot, bus=self.bus, route=self.route)
        self.client.force_authenticate(self.pilot)

        response = self.client.post(
            '/api/trips/end/', {'trip_id': trip.id}, format='json'
        )

        self.assertEqual(response.status_code, 200)
        trip.refresh_from_db()
        self.assertEqual(trip.status, Trip.Status.COMPLETED)
        self.assertIsNotNone(trip.end_time)
        self.assertEqual(response.data['status'], 'COMPLETED')
        self.assertIn('end_time', response.data)
        self.assertTrue(Trip.objects.filter(pk=trip.pk).exists())
        self.assertFalse(
            Trip.objects.filter(status=Trip.Status.ACTIVE).exists()
        )

    def test_different_pilot_cannot_end_trip(self):
        trip = Trip.objects.create(pilot=self.pilot, bus=self.bus, route=self.route)
        other_pilot = get_user_model().objects.create_user(username='other-pilot')
        UserProfile.objects.create(user=other_pilot, role=UserProfile.Role.PILOT)
        self.client.force_authenticate(other_pilot)

        response = self.client.post(
            '/api/trips/end/', {'trip_id': trip.id}, format='json'
        )

        self.assertEqual(response.status_code, 403)
        trip.refresh_from_db()
        self.assertEqual(trip.status, Trip.Status.ACTIVE)
        self.assertIsNone(trip.end_time)

    def test_passenger_cannot_end_trip(self):
        trip = Trip.objects.create(pilot=self.pilot, bus=self.bus, route=self.route)
        self.client.force_authenticate(self.passenger)

        response = self.client.post(
            '/api/trips/end/', {'trip_id': trip.id}, format='json'
        )

        self.assertEqual(response.status_code, 403)
        trip.refresh_from_db()
        self.assertEqual(trip.status, Trip.Status.ACTIVE)

    def test_anonymous_user_cannot_end_trip(self):
        trip = Trip.objects.create(pilot=self.pilot, bus=self.bus, route=self.route)

        response = self.client.post(
            '/api/trips/end/', {'trip_id': trip.id}, format='json'
        )

        self.assertEqual(response.status_code, 401)


class ActiveTripsWebsocketTests(TransactionTestCase):
    def setUp(self):
        user_model = get_user_model()
        self.pilot = user_model.objects.create_user(username='ws-pilot')
        UserProfile.objects.create(user=self.pilot, role=UserProfile.Role.PILOT)
        self.bus = Bus.objects.create(
            registration_number='KA-34-A-3003', pilot=self.pilot
        )
        self.route = Route.objects.create(
            source_name='Ballari', destination_name='Kampli'
        )
        self.client = APIClient()
        self.client.force_authenticate(self.pilot)

    def test_trip_start_and_end_events_are_broadcast_to_passengers(self):
        async def exercise_websocket():
            communicator = WebsocketCommunicator(
                application,
                '/ws/active-trips/',
                headers=[
                    (b'host', b'localhost'),
                    (b'origin', b'http://localhost'),
                ],
            )
            connected, _ = await communicator.connect()
            self.assertTrue(connected)
            snapshot = await communicator.receive_json_from()
            self.assertEqual(snapshot, {'event': 'active_trips', 'trips': []})

            response = await sync_to_async(
                self.client.post, thread_sensitive=True
            )(
                '/api/trips/start/',
                {'route_id': self.route.id, 'bus_id': self.bus.id},
                format='json',
            )
            self.assertEqual(response.status_code, 201)
            event = await communicator.receive_json_from()
            self.assertEqual(
                event,
                {
                    'event': 'trip_started',
                    'trip_id': response.data['trip_id'],
                    'route': 'Ballari - Kampli',
                    'status': 'ACTIVE',
                },
            )

            end_response = await sync_to_async(
                self.client.post, thread_sensitive=True
            )(
                '/api/trips/end/',
                {'trip_id': response.data['trip_id']},
                format='json',
            )
            self.assertEqual(end_response.status_code, 200)
            ended_event = await communicator.receive_json_from()
            self.assertEqual(
                ended_event,
                {
                    'event': 'trip_ended',
                    'trip_id': response.data['trip_id'],
                    'status': 'COMPLETED',
                },
            )
            await communicator.disconnect()

        async_to_sync(exercise_websocket)()
