import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_browser/my_browser.dart';

void main() {
  const MethodChannel channel = MethodChannel('my_browser');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await MyBrowser.platformVersion, '42');
  });
}
