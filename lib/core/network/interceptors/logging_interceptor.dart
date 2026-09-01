import 'package:flutter/foundation.dart';

abstract class LoggingInterceptor {
  static void logRequest(String method, String url, {Map<String, dynamic>? body}) {
    if (kDebugMode) {
      debugPrint('[HTTP Request] $method -> $url');
      if (body != null) {
        debugPrint('[HTTP Body] $body');
      }
    }
  }

  static void logResponse(int statusCode, String url, {dynamic data}) {
    if (kDebugMode) {
      debugPrint('[HTTP Response $statusCode] <- $url');
    }
  }

  static void logError(String url, dynamic error) {
    if (kDebugMode) {
      debugPrint('[HTTP Error] $url: $error');
    }
  }
}
