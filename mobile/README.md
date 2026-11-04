# KKRTC Where Is My Bus?

## Android Google Maps setup

Create a restricted Google Maps API key with Maps SDK for Android enabled. Set the key in the build environment so Gradle can place it in the Android manifest, and pass the same value to Dart:

```powershell
$env:GOOGLE_MAPS_API_KEY = '<your restricted key>'
flutter run --dart-define=GOOGLE_MAPS_API_KEY=$env:GOOGLE_MAPS_API_KEY
```

The app intentionally shows a configuration message when this key is absent. Places Autocomplete and Directions are not connected in this workspace.

## Backend status

The checked-in Django URL configuration currently exposes only `/api/health/`. Passenger route/trip search, assigned trips, trip start/stop, authentication, and passenger/pilot GPS endpoints are not present. Until those endpoints are deployed and the mobile API is wired to them, trip search and live tracking remain unavailable; the app does not substitute demo bus positions or telemetry.

## Required brand asset

The logo reveal video is registered at `assets/video/kkrtc_logo_reveal.mp4`. The supplied standalone app-logo PNG was not found. Add it at `assets/images/kkrtc_app_logo.png` before replacing the default Flutter launcher artwork in the Android `mipmap-*` resources.
