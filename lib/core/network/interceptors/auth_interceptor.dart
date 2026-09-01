import 'dart:async';

abstract class AuthInterceptor {
  static Future<Map<String, String>> getAuthHeaders(String? token) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}
