import 'package:flutter_test/flutter_test.dart';
import 'package:nertc_faceunity_plugin/nertc_faceunity_plugin.dart';
import 'package:nertc_faceunity_plugin/nertc_faceunity_plugin_platform_interface.dart';
import 'package:nertc_faceunity_plugin/nertc_faceunity_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNertcFaceunityPluginPlatform
    with MockPlatformInterfaceMixin
    implements NertcFaceunityPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NertcFaceunityPluginPlatform initialPlatform = NertcFaceunityPluginPlatform.instance;

  test('$MethodChannelNertcFaceunityPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNertcFaceunityPlugin>());
  });

  test('getPlatformVersion', () async {
    NertcFaceunityPlugin nertcFaceunityPlugin = NertcFaceunityPlugin();
    MockNertcFaceunityPluginPlatform fakePlatform = MockNertcFaceunityPluginPlatform();
    NertcFaceunityPluginPlatform.instance = fakePlatform;

    expect(await nertcFaceunityPlugin.getPlatformVersion(), '42');
  });
}
