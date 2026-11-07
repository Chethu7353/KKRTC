import 'osm_map_panel.dart';

export 'package:latlong2/latlong.dart' show LatLng;

export 'osm_map_panel.dart';

/// Backward-compatible alias for existing imports during OpenStreetMap transition.
@Deprecated('Use OsmMapPanel instead for OpenStreetMap integration')
typedef GoogleMapPanel = OsmMapPanel;
