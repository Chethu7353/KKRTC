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

## Branding assets

The supplied logo PNG and reveal video are registered from `assets/images/kkrtc_app_logo.png` and `assets/video/kkrtc_logo_reveal.mp4`. The Android launcher icon uses a square bus-and-pin crop derived from the original PNG, with the adaptive icon background set to deep navy. Regenerate Android icon resources after editing the icon config with `dart run flutter_launcher_icons`.

At launch, the app shows a short navy ambient lead-in, plays the complete reveal video once, and then opens Passenger/Pilot selection. Since the video already contains the complete Kannada wordmark and BUS TRACKER tagline, the static full-logo PNG is reserved for the playback-error fallback instead of repeating the reveal.
