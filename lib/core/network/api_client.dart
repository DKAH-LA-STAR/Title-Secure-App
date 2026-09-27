import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import '../services/secure_storage.dart';
import 'interceptors/auth_interceptor.dart';

class ApiClient {
  final Dio dio;

  ApiClient({
    String? baseUrl,
    Dio? customDio,
    SecureStorageService? storageService,
  }) : dio = customDio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? ApiEndpoints.baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    if (customDio == null) {
      dio.interceptors.add(_FallbackHostInterceptor());
      if (storageService != null) {
        dio.interceptors.add(AuthInterceptor(storageService: storageService));
      }
    }
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
    return response.data;
  }

  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await dio.post(
      path,
      data: body,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
    return response.data;
  }

  Future<dynamic> put(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await dio.put(
      path,
      data: body,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
    return response.data;
  }

  Future<dynamic> delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await dio.delete(
      path,
      data: body,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
    return response.data;
  }
}

/// Automatically retries connection failures across available network hosts:
/// 127.0.0.1 (physical device with adb reverse, or local tests)
/// 192.168.1.75 (physical device over local Wi-Fi without adb reverse)
/// 10.0.2.2 (Android emulator)
class _FallbackHostInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final uri = err.requestOptions.uri;
    final isConnectionFailure =
        err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.connectionError;

    if (isConnectionFailure) {
      final List<String> triedHosts = List<String>.from(
        err.requestOptions.extra['tried_hosts'] as List? ?? [uri.host],
      );

      final candidateHosts = ['127.0.0.1', '192.168.1.75', '10.0.2.2'];
      final nextHost = candidateHosts.firstWhere(
        (h) => !triedHosts.contains(h),
        orElse: () => '',
      );

      if (nextHost.isNotEmpty) {
        final newUri = uri.replace(host: nextHost);
        final newOptions = err.requestOptions.copyWith(
          path: newUri.toString(),
          extra: {
            ...err.requestOptions.extra,
            'tried_hosts': [...triedHosts, nextHost],
          },
        );

        try {
          final client = Dio(BaseOptions(
            connectTimeout: const Duration(seconds: 3),
            receiveTimeout: const Duration(seconds: 8),
            headers: err.requestOptions.headers,
          ));
          final response = await client.fetch(newOptions);
          // Remember the successful base URL for subsequent calls
          ApiEndpoints.setBaseUrl('http://$nextHost:${uri.port}/api');
          return handler.resolve(response);
        } catch (_) {
          // If fallback also fails, continue onError handler chain
        }
      }
    }
    return handler.next(err);
  }
}
