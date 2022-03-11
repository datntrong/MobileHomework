// ignore_for_file: unused_local_variable, avoid_print

import 'dart:async';

import 'package:flutter/services.dart';

class MyBrowser {
  static const MethodChannel _channel = MethodChannel('my_browser');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<void> openBrowser(String urlString) async {
    try {
      final int result = await _channel
          .invokeMethod('openBrowser', <String, String>{'url': urlString});
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
