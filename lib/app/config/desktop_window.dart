import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class DesktopWindowConfig {
  static Future<void> initialize() async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      await windowManager.ensureInitialized();

      const windowOptions = WindowOptions(
        size: Size(1500, 1000),
        minimumSize: Size(1200, 800),

        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        // fullScreen: true,
        // titleBarStyle: TitleBarStyle.hidden, // Custom titlebar support
        title: 'Mattermost Desktop',
      );

      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }
}
