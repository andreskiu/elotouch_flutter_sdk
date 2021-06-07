import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ElotouchFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('elotouch_flutter_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> printString({@required dynamic args}) async {
    print("POR EJECUTAR EL METHOD PRINT");
    try {
      final String version = await _channel.invokeMethod('print', args);
      print("version: " + version);
      return version;
    } on Exception catch (e) {
      print("EXECUTION FAILS");
      print(e);
    }
    return null;
  }
}
