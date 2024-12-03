import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'app/app.dart';
import 'get_it/get_it.config.dart';

final log = Logger('ROOT');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Flame.device.fullScreen();
  }
  GetIt.I.init();
  await Flame.device.setOrientation(DeviceOrientation.portraitUp);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    // systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    log.info('${record.level.name}: ${record.time}: ${record.message}');
  });
  FlutterError.onError = (errorDetails) {
    log.shout(errorDetails.library, errorDetails.exceptionAsString(),
        errorDetails.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    log.shout('PlatformDispatcher', error, stack);
    return true;
  };

  runApp(const App());
}
