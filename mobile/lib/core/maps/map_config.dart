/// Configuration for OpenStreetMap integration.
///
/// Ensures tile URLs, user-agent headers, and tile providers are fully configurable
/// per OpenStreetMap Tile Usage Policy.
class MapConfig {
  /// Base tile URL template for OpenStreetMap tiles.
  /// Configurable at runtime or compile-time via --dart-define=OSM_TILE_URL=...
  /// Default: official OpenStreetMap tile server.
  static const String tileUrlTemplate = String.fromEnvironment(
    'OSM_TILE_URL',
    defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );

  /// Application identifier sent in the HTTP User-Agent header,
  /// required by OpenStreetMap's Tile Usage Policy to prevent 403 Forbidden responses.
  static const String userAgentPackageName = String.fromEnvironment(
    'OSM_USER_AGENT',
    defaultValue: 'in.kkrtc.kkrtc_bus',
  );

  /// OpenStreetMap standard attribution notice.
  static const String attribution = '© OpenStreetMap contributors';

  /// Default center coordinates for KKRTC operational zone (Kalyana Karnataka / Kalaburagi).
  static const double defaultLatitude = 17.3297;
  static const double defaultLongitude = 76.8343;
  static const double defaultZoom = 13.0;

  /// Check whether tile URL is configured and non-empty.
  static bool get isConfigured => tileUrlTemplate.trim().isNotEmpty;
}
