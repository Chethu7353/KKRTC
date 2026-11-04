class GoogleMapsConfig {
  static const apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static bool get isConfigured => apiKey.trim().isNotEmpty;
}
