library ns_logs;

import 'package:flutter/material.dart';
import 'package:ns_logs/dev_screen/dev_screen.dart';

import 'logs/logs.dart';

export 'api/api_constants.dart';
export 'api/dev_api_service.dart';
export 'logs/logs.dart';

NsLogs nsLog = NsLogs();

class NsLogs {
  List<String> logTypes = AppLogTag.defaultLogTypes;
  String baseUrl = "";

  Function rawParserConditions = () {};

  void setNSLog({required List<String> logTypes}) {
    logTypes = logTypes;
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
