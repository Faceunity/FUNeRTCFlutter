import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nertc_faceunity_plugin_method_channel.dart';

abstract class NertcFaceunityPluginPlatform extends PlatformInterface {
  /// Constructs a NertcFaceunityPluginPlatform.
  NertcFaceunityPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static NertcFaceunityPluginPlatform _instance = MethodChannelNertcFaceunityPlugin();

  /// The default instance of [NertcFaceunityPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelNertcFaceunityPlugin].
  static NertcFaceunityPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NertcFaceunityPluginPlatform] when
  /// they register themselves.
  static set instance(NertcFaceunityPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> enableFuBeauty(bool enable) {
    throw UnimplementedError('enableFuBeauty() has not been implemented.');
  }
}
