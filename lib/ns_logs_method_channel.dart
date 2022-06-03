import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ns_logs_platform_interface.dart';

/// An implementation of [NsLogsPlatform] that uses method channels.
class MethodChannelNsLogs extends NsLogsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ns_logs');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
