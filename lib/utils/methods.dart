import 'package:flutter/services.dart';

import '../app_toast/app_toast.dart';

/// copyToClipBoard
Future<void> copyToClipBoard({
  required String value,
}) async {
  await Clipboard.setData(
    ClipboardData(text: value),
  );
  AppToast.showSuccess('Copied!');
}
