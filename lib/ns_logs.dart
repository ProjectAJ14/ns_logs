library ns_logs;

import 'package:flutter/material.dart';
import 'package:ns_logs/api/api.dart';
import 'package:ns_logs/dev_screen/dev_screen.dart';

import 'logs/logs.dart';

export 'api/api.dart';
export 'api/api.dart';
export 'api/api_constants.dart';
export 'api/dev_api_service.dart';
export 'logs/logs.dart';

NsLogs nsLog = NsLogs();

class NsLogs {
  List<String> logTypes = AppLogTag.defaultLogTypes;
  String baseUrl = "";
  Map<String, dynamic> headers = defaultMapHeaders;

  Function rawParserConditions = () {};

  void setNSLog({required List<String> logTypes}) {
    logTypes = logTypes;
  }

  void setBaseUrl(String baseUrl, {required Map<String, String> headers}) {
    this.baseUrl = baseUrl;
    this.headers = headers;
    if (baseUrl.isNotEmpty) {
      AppAPI.setBaseURL(baseUrl);
    } else {
      appLogs("Base url is empty");
    }
  }

  void rawParseConditions(Function rawParserConditions) {
    rawParserConditions = rawParserConditions;
  }

  void openDevScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DevScreen(),
      ),
    );
  }
}
