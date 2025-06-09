// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../game_controller/game_controller.dart';
import 'logger.dart';

void watchRecords(LogRecord rec) {
  // ---- filter --------
  if (rec.stackTrace != null) {
    debugPrintStack(
      stackTrace: rec.stackTrace,
      label: '${rec.level.color}:${rec.loggerName}: $red${rec.message}$reset',
    );
    return;
  }
  if (kDebugMode) {
    // reset level for all logger
    Logger(GameInstruction.loggerName).level = Level.ALL;
  }
  debugPrint('${rec.level.color}:${rec.loggerName}: ${rec.message}');
}
