// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab_10/main.dart';

void main() {
  testWidgets('App renders splash screen smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const Lab10FullApp());

    // Verify that the splash screen shows loading text
    expect(find.text('Đang kiểm tra phiên đăng nhập (Auto-Login)...'), findsOneWidget);

    // Advance time past the 2s delay
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
  });
}
