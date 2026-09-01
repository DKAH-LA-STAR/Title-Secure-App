import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';

class ApiClient {
  final Dio dio;

  ApiClient({String baseUrl = ApiEndpoints.baseUrl, Dio? customDio})
      : dio = customDio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            );

  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    final response = await dio.get(path, options: Options(headers: headers));
    return response.data;
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    final response = await dio.post(path, data: body, options: Options(headers: headers));
    return response.data;
  }
}
