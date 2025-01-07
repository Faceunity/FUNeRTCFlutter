import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'nertc_faceunity_plugin_platform_interface.dart';

/// An implementation of [NertcFaceunityPluginPlatform] that uses method channels.
class MethodChannelNertcFaceunityPlugin extends NertcFaceunityPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nertc_faceunity_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int?> enableFuBeauty(bool enable) async {
    final result = await methodChannel.invokeMethod<int>('enableFuBeauty', {'enable': enable});
    return result;
  }
}
