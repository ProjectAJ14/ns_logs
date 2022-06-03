import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ns_logs_method_channel.dart';

abstract class NsLogsPlatform extends PlatformInterface {
  /// Constructs a NsLogsPlatform.
  NsLogsPlatform() : super(token: _token);

  static final Object _token = Object();

  static NsLogsPlatform _instance = MethodChannelNsLogs();

  /// The default instance of [NsLogsPlatform] to use.
  ///
  /// Defaults to [MethodChannelNsLogs].
  static NsLogsPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NsLogsPlatform] when
  /// they register themselves.
  static set instance(NsLogsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
