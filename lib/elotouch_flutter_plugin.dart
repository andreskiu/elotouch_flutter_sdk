
import 'dart:async';

import 'package:flutter/services.dart';

class ElotouchFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('elotouch_flutter_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
