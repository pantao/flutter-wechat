import 'dart:async';

import 'package:flutter/services.dart';

/// Wechat Plugin for Flutter App
class Wechat {
  static const MethodChannel _channel =
      const MethodChannel('wechat');

  /// Get platform version
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Register app to Wechat with [appid]
  static Future<dynamic> register(String appid) async {
    var result = await _channel.invokeMethod(
      'register',
      {
        'appid': appid
      }
    );
    return result;
  }

  /// Check if wechat app has was installed.
  static Future<dynamic> isWechatInstalled() async {
    var result = await _channel.invokeMethod(
      'isWechatInstalled'
    );
    return result == 'true' ? true : false;
  }

  /// Get wechat sdk api version.
  static Future<dynamic> getApiVersion() async {
    var result = await _channel.invokeMethod(
      'getApiVersion'
    );
    return result;
  }

  /// open wechat app.
  static Future<dynamic> openWechat() async {
    var result = await _channel.invokeMethod(
      'openWechat'
    );
    return result;
  }

  /// Sharing
  /// 
  /// arguments object structure
  /// 
  /// ```
  /// {
  ///   "kind": "text",
  ///   "to": "session",
  ///   "title": "the title of message",
  ///   "description": "short description of message.",
  ///   "coverUrl": "https://example.com/path/to/cover/image.jpg",
  ///   "resourceUrl": "https://example.com/path/to/resource.mp4"
  /// }
  /// ```
  /// 
  /// when kind is `music` or `video`, the `resourceUrl` means the data url of the mucis or video
  static Future<dynamic> share(Map<String, dynamic> arguments) async {
    arguments['kind'] = arguments['kind'] ?? 'text';
    arguments['to'] = arguments['to'] ?? 'session';

    var result = await _channel.invokeMethod(
      'share',
      arguments
    );

    return result;
  }

  /// Login
  /// 
  /// arguments object structure:
  /// 
  /// ```
  /// {
  ///   "scope": "snsapi_userinfo",
  ///   "state": "customestate"
  /// }
  /// ```
  static Future<dynamic> login(Map<String, String> arguments) async {
    arguments['scope'] = arguments['scope'] ?? 'snsapi_userinfo';

    var result = await _channel.invokeMethod(
      'login',
      arguments
    );
    return result;
  }

  /// Pay
  /// 
  /// arguments object structure:
  /// 
  /// ```
  /// {
  ///   "partnerId": "partnerId",
  ///   "prepayId": "prepayId",
  ///   "package": "package",
  ///   "nonceStr": "nonceStr",
  ///   "timestamp": "timestamp",
  ///   "sign": "sign"
  /// }
  /// ```
  static Future<dynamic> pay(Map<String, String> arguments) async {
    var result = await _channel.invokeMethod(
      'pay',
      arguments
    );
    return result;
  }
}
