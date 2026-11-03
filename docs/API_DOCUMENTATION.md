# KKRTC – API Documentation Specification

Base URL: `http://<host>:8000/api`  
Protocol: HTTP/REST (JSON) + WebSocket (`ws://<host>:8000/ws`)  
Authentication: Bearer JWT (`Authorization: Bearer <access_token>`)  

---

## 1. Authentication Endpoints
- `POST /api/auth/login/` – Authenticate with phone/username and password.
- `POST /api/auth/token/refresh/` – Refresh expired access tokens.
- `GET /api/auth/profile/` – Current user profile and role details.

## 2. Driver Endpoints
- `GET /api/driver/assigned-trips/` – List trips assigned to authenticated driver/conductor.
- `POST /api/driver/trips/{id}/start-duty/` – Activate duty and initialize trip tracking.
- `POST /api/driver/trips/{id}/stop-duty/` – Terminate duty and finalize trip.
- `POST /api/driver/location/` – Transmit authenticated driver GPS telemetry.

## 3. Passenger Endpoints
- `GET /api/passenger/trips/search/?from={stop_id}&to={stop_id}` – Search active and scheduled buses.
- `GET /api/passenger/trips/{id}/details/` – View trip route, intermediate stops, and live status.
- `POST /api/passenger/trips/{id}/join/` – Request boarding verification session.
- `POST /api/passenger/trips/{id}/verify-qr/` – Verify boarding via bus QR code.
- `POST /api/passenger/location/` – Submit consented passenger GPS coordinates.
- `POST /api/passenger/trips/{id}/leave/` – Terminate passenger tracking session.
- `GET /api/passenger/trips/{id}/live-location/` – Retrieve fused live bus location and ETA.

## 4. Real-Time WebSockets
- `WS /ws/trips/{trip_id}/live/` – Bi-directional channel streaming live coordinate updates, ETA revisions, and stop arrivals.
