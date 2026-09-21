import 'package:dio/dio.dart';
import '../../services/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService storageService;

  AuthInterceptor({required this.storageService});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storageService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    if (options.data is! FormData) {
      options.headers['Content-Type'] = 'application/json';
    }
    options.headers['Accept'] = 'application/json';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      storageService.deleteToken();
    }
    handler.next(err);
  }
}
