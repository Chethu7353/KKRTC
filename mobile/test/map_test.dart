import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:kkrtc_bus/core/maps/map_config.dart';
import 'package:kkrtc_bus/shared/widgets/osm_map_panel.dart';

void main() {
  group('OpenStreetMap Configuration & Widget Tests', () {
    test(
      'MapConfig specifies valid OpenStreetMap tile URL and attribution',
      () {
        expect(MapConfig.isConfigured, isTrue);
        expect(MapConfig.tileUrlTemplate, contains('tile.openstreetmap.org'));
        expect(MapConfig.attribution, contains('OpenStreetMap'));
        expect(MapConfig.userAgentPackageName, isNotEmpty);
        expect(MapConfig.defaultLatitude, closeTo(17.3297, 0.01));
        expect(MapConfig.defaultLongitude, closeTo(76.8343, 0.01));
      },
    );

    testWidgets(
      'OsmMapPanel renders zoom and location controls with route coordinates',
      (WidgetTester tester) async {
        const origin = LatLng(17.3297, 76.8343);
        const destination = LatLng(17.3350, 76.8400);
        const busLocation = LatLng(17.3320, 76.8370);
        const routeCoords = [origin, busLocation, destination];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 400,
                width: 400,
                child: OsmMapPanel(
                  origin: origin,
                  destination: destination,
                  busLocation: busLocation,
                  routeCoordinates: routeCoords,
                ),
              ),
            ),
          ),
        );

        // Verify controls exist
        expect(find.byTooltip('Zoom in'), findsOneWidget);
        expect(find.byTooltip('Zoom out'), findsOneWidget);
        expect(find.byTooltip('My location'), findsOneWidget);

        // Verify OpenStreetMap attribution is displayed
        expect(find.text(MapConfig.attribution), findsOneWidget);
      },
    );

    testWidgets(
      'OsmMapPanel displays notice when no coordinates are available',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(height: 400, width: 400, child: OsmMapPanel()),
            ),
          ),
        );

        expect(
          find.text('Enable location to open the live map.'),
          findsOneWidget,
        );
        expect(find.text('Use current location'), findsOneWidget);
      },
    );
  });
}
