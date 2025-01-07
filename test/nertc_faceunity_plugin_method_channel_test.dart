import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nertc_faceunity_plugin/nertc_faceunity_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelNertcFaceunityPlugin platform = MethodChannelNertcFaceunityPlugin();
  const MethodChannel channel = MethodChannel('nertc_faceunity_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
