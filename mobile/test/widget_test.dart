import 'package:flutter_test/flutter_test.dart';
import 'package:kkrtc_bus/app.dart';

void main() {
  testWidgets('KKRTC app foundation smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KKRTCApp());
    expect(find.text('KKRTC'), findsOneWidget);
    expect(find.text('PHASE 1 FOUNDATION ACTIVE'), findsOneWidget);
  });
}
