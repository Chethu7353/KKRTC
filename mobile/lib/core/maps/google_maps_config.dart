import 'map_config.dart';

@Deprecated('Use MapConfig for OpenStreetMap instead')
class GoogleMapsConfig {
  static const apiKey = '';
  static bool get isConfigured => MapConfig.isConfigured;
}
