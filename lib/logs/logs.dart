import 'package:let_log/let_log.dart' as let_log;

import '../ns_logs.dart';

/// AppLogTag
class AppLogTag {
  /// info
  static const String info = 'I️NFO️';

  /// api
  static const String api = 'API INFO';

  /// error
  static const String error = 'ERROR';

  /// warning
  static const String warning = 'WARNING';

  /// warning
  static const String repo = 'REPO';

  /// warning
  static const String config = 'CONFIG';

  static const List<String> defaultLogTypes = [
    info,
    api,
    error,
    warning,
    config
  ];
}

///[appLogs,apiLogs,errorLogs] functions should be
///user to print logs and not `print`

///print Logs on console with tag [AppLogTag.info]
///
void appLogs(Object? object, [Object? detail]) {
  if (nsLog.logTypes.contains(AppLogTag.info)) {
    let_log.Logger.log(object!, detail);
  }
}

///print Logs on console with tag [AppLogTag.info]
///
void repoLogs(Object object, [Object? detail]) {
  if (nsLog.logTypes.contains(AppLogTag.repo)) {
    let_log.Logger.debug(object, detail);
  }
}

///print Logs on console with tag [AppLogTag.api]
///
void apiLogs(Object object, [Object? detail]) {
  if (nsLog.logTypes.contains(AppLogTag.api)) {
    let_log.Logger.debug(object, detail);
  }
}

///print Logs on console with tag [AppLogTag.warning]
///
void warnLogs(Object object, [Object? detail]) {
  if (nsLog.logTypes.contains(AppLogTag.warning)) {
    let_log.Logger.warn(object, detail);
  }
}

///print Logs on console with tag [AppLogTag.warning]
///
void configLogs(Object object, [Object? detail]) {
  if (nsLog.logTypes.contains(AppLogTag.config)) {
    let_log.Logger.warn(object, detail);
  }
}

///print Logs on console with tag [AppLogTag.error]
///
void errorLogs(
  Object object, [
  dynamic error,
  StackTrace? stackTrace,
]) {
  if (nsLog.logTypes.contains(AppLogTag.error)) {
    let_log.Logger.error('$object\n$error', stackTrace);
  }
}
