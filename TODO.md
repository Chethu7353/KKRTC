# KKRTC – Where Is My Bus? Development Tasks & Roadmap

## Phase 1: Foundation (Current)
- [x] Verify toolchain: Flutter, Dart, Python, Docker, PostgreSQL, Git
- [x] Scaffold repository directory structure
- [x] Configure Docker Compose with PostGIS 16-3.4
- [x] Verify PostgreSQL connectivity and database migrations
- [x] Initialize Django 5.0 backend with modular apps (accounts, buses, routes, trips, tracking, eta, notifications)
- [x] Initialize Flutter mobile client with Material 3 branding and bilingual constants
- [x] Run static analysis (`flutter analyze`) and widget tests (`flutter test`)
- [x] Generate system architecture and database documentation

## Phase 2: Backend Foundation (Next)
- [ ] Implement custom `UserProfile` model and JWT role authentication
- [ ] Create `Bus`, `Route`, `Stop`, and `RouteStop` models with spatial fields
- [ ] Create `Trip`, `DriverAssignment`, and `PassengerTripSession` models
- [ ] Implement REST APIs for bus lookup, route traversal, and stop listing
- [ ] Seed demonstration route data: Ballari ↔ Gangavathi
- [ ] Write automated backend unit and integration tests

## Phase 3: Driver Application
- [ ] Driver/Conductor authentication flow
- [ ] Driver dashboard displaying assigned bus, route, and active trip status
- [ ] Implement Start Duty / Stop Duty lifecycle
- [ ] Background Android geolocation service with foreground notification
- [ ] Driver telemetry ingestion API

## Phase 4: Passenger Application
- [ ] Passenger home screen with From/To route search
- [ ] Live route results showing ETA and bus operational status
- [ ] Interactive tracking map with route polyline and live vehicle markers
- [ ] Visual indicators distinguishing LIVE, DELAYED, and STALE locations

## Phase 5: Passenger-Assisted Tracking & Fusion
- [ ] "I AM IN THIS BUS" boarding workflow and QR token verification
- [ ] Explicit privacy consent and passenger geolocation collection
- [ ] GPS validation engine (speed, boundary, accuracy, corridor checks)
- [ ] Crowdsourced spatial fusion engine with outlier rejection

## Phase 6: Real-Time Communication & ETA Engine
- [ ] Django Channels WebSocket integration for trip live updates
- [ ] Distance-and-speed based deterministic ETA engine
- [ ] Push location updates to Flutter client via WebSockets

## Phase 7: Production Hardening
- [ ] Comprehensive test suite execution (end-to-end integration tests)
- [ ] Security audits, rate limiting, and CORS verification
- [ ] Release APK/AAB build generation for Android
