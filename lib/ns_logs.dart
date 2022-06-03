library ns_logs;

import 'package:ns_logs/api/api.dart';

import 'logs/logs.dart';

export 'api/api.dart';
export 'api/api.dart';
export 'api/api_constants.dart';
export 'api/dev_api_service.dart';
export 'logs/logs.dart';

AppLogs nsLog = AppLogs();

class AppLogs {
  List<String> logTypes = AppLogTag.defaultLogTypes;
  String baseUrl = "";
  Map<String, dynamic> headers = defaultMapHeaders;

  Function rawParserConditions = () {};

  void setNSLog({required List<String> logTypes}) {
    logTypes = logTypes;
  }

  void setBaseUrl(String baseUrl, {required Map<String, String> headers}) {
    baseUrl = baseUrl;
    headers = headers;
    if (baseUrl.isNotEmpty) {
      AppAPI.setBaseURL(baseUrl);
    } else {
      appLogs("Base url is empty");
    }
  }

  void rawParseConditions(Function rawParserConditions) {
    rawParserConditions = rawParserConditions;
  }
}
