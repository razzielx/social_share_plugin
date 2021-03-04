import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

typedef Future<dynamic> OnCancelHandler();
typedef Future<dynamic> OnErrorHandler(String error);
typedef Future<dynamic> OnSuccessHandler(String postId);

class SocialSharePlugin {
  static const MethodChannel _channel =
      const MethodChannel('social_share_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> shareToFeedInstagram({
    String type = 'image/*',
    required String path,
    required OnSuccessHandler onSuccess,
    required OnCancelHandler onCancel,
  }) async {
    _channel.setMethodCallHandler((call) {
      switch (call.method) {
        case "onSuccess":
          return onSuccess(call.arguments);
        case "onCancel":
          return onCancel();
        default:
          throw UnsupportedError("Unknown method called");
      }
    });
    return _channel.invokeMethod('shareToFeedInstagram', <String, dynamic>{
      'type': type,
      'path': path,
    });
  }

  static Future<void> shareToFeedFacebookPhoto({
    String? caption,
    String? hashtag,
    required String path,
    required OnSuccessHandler onSuccess,
    required OnCancelHandler onCancel,
    required OnErrorHandler onError,
  }) async {
    if (path.startsWith('http')) {
      throw Exception(
          'path must be a local file path, maybe you should use url parameter!');
    }
    _channel.setMethodCallHandler((call) {
      switch (call.method) {
        case "onSuccess":
          return onSuccess(call.arguments);
        case "onCancel":
          return onCancel();
        case "onError":
          return onError(call.arguments);
        default:
          throw UnsupportedError("Unknown method called");
      }
    });
    String filePath = path;

    return _channel.invokeMethod('shareToFeedFacebookPhoto', <String, dynamic>{
      'caption': caption,
      'path': filePath,
      'hashtag': hashtag,
    });
  }

  static Future<void> shareToFeedFacebookVideo({
    String? hashtag,
    required String path,
    required OnSuccessHandler onSuccess,
    required OnCancelHandler onCancel,
    required OnErrorHandler onError,
  }) async {
    if (Platform.isAndroid && path == null) {
      throw Exception('path is required!');
    }
    if (Platform.isIOS && path != null) {
      print('WARNING: in shareToFeedFacebookVideo path is not used!');
    }
    _channel.setMethodCallHandler((call) {
      switch (call.method) {
        case "onSuccess":
          return onSuccess(call.arguments);
        case "onCancel":
          return onCancel();
        case "onError":
          return onError(call.arguments);
        default:
          throw UnsupportedError("Unknown method called");
      }
    });
    return _channel.invokeMethod('shareToFeedFacebookVideo', <String, dynamic>{
      'path': path,
      'hashtag': hashtag ?? '',
    });
  }

  static Future<dynamic> shareToFeedFacebookLink({
    String? quote,
    String? hashtag,
    required String url,
    required OnSuccessHandler onSuccess,
    required OnCancelHandler onCancel,
    required OnErrorHandler onError,
  }) async {
    _channel.setMethodCallHandler((call) {
      switch (call.method) {
        case "onSuccess":
          return onSuccess(call.arguments);
        case "onCancel":
          return onCancel();
        case "onError":
          return onError(call.arguments);
        default:
          throw UnsupportedError("Unknown method called");
      }
    });
    return _channel.invokeMethod('shareToFeedFacebookLink', <String, dynamic>{
      'quote': quote,
      'url': url,
      'hashtag': hashtag,
    });
  }

  static Future<dynamic> shareToTwitterLink({
    required String text,
    required String url,
    required OnSuccessHandler onSuccess,
    required OnCancelHandler onCancel,
  }) async {
    _channel.setMethodCallHandler((call) {
      switch (call.method) {
        case "onSuccess":
          return onSuccess(call.arguments);
        case "onCancel":
          return onCancel();
        //  case "onError":
        //    return onError(call.arguments);
        default:
          throw UnsupportedError("Unknown method called");
      }
    });
    return _channel.invokeMethod('shareToTwitterLink', <String, dynamic>{
      'text': text,
      'url': url,
    });
  }
}
