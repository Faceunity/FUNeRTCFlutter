
import 'nertc_faceunity_plugin_platform_interface.dart';

class NertcFaceunityPlugin {
  Future<String?> getPlatformVersion() {
    return NertcFaceunityPluginPlatform.instance.getPlatformVersion();
  }
  Future<int?> enableFuBeauty(bool enable) {
    return NertcFaceunityPluginPlatform.instance.enableFuBeauty(enable);
  }
}
