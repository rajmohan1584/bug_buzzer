import 'dart:async';
import 'dart:io';

import 'package:bug_buzzer/home.dart';
import 'package:bug_buzzer/log.dart';
import 'package:bug_buzzer/server_direct.dart';
import 'package:bug_buzzer/single_multicast.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*
  // TODO get it grom MCAST
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  CONST.appVersion = packageInfo.version;
  */

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1024, 850),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    // Use it only after calling `hiddenWindowAtLaunch`
    windowManager.waitUntilReadyToShow(windowOptions).then((_) async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  StaticSingleMultiCast.initListener();
  ServerDirectReceiver.start();

  runZonedGuarded(() {
    runApp(const MyApp());
  }, (Object error, StackTrace stack) {
    Log.log(error);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
