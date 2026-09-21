import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? role,
    String? phoneNumber,
  });

  Future<UserModel> getCurrentUser();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  Never _handleDioError(DioException e) {
    final responseData = e.response?.data;
    String message = 'An unexpected error occurred';
    if (responseData is Map<String, dynamic>) {
      // Check for Laravel validation error bag: {"errors": {"field": ["msg"]}}
      if (responseData['errors'] is Map) {
        final errorsMap = responseData['errors'] as Map;
        final errorList = <String>[];
        errorsMap.forEach((key, val) {
          if (val is List) {
            errorList.addAll(val.map((item) => item.toString()));
          } else if (val != null) {
            errorList.add(val.toString());
          }
        });
        if (errorList.isNotEmpty) {
          message = errorList.join('\n');
        } else {
          message = responseData['message']?.toString() ??
              responseData['error']?.toString() ??
              message;
        }
      } else {
        message = responseData['message']?.toString() ??
            responseData['error']?.toString() ??
            message;
      }
    } else if (e.message != null && e.message!.isNotEmpty) {
      message = e.message!;
    }

    final statusCode = e.response?.statusCode;
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw NetworkException(message.contains('unexpected')
          ? 'Network connection failure. Please check your internet connection or verify the server is running.'
          : message);
    }

    if (statusCode == 401) {
      throw AuthException(message, statusCode);
    } else if (statusCode != null && statusCode >= 500) {
      throw ServerException(message, statusCode);
    } else {
      throw ApiException(message, statusCode);
    }
  }

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email.trim().toLowerCase(),
          'password': password,
        },
      );
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return <String, dynamic>{'data': response.data};
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? role,
    String? phoneNumber,
  }) async {
    try {
      final payload = <String, dynamic>{
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
      if (role != null && role.isNotEmpty) {
        payload['role'] = role.toLowerCase();
      }
      if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
        payload['phone_number'] = phoneNumber.trim();
        payload['phone'] = phoneNumber.trim();
      }

      final response = await apiClient.dio.post(
        ApiEndpoints.register,
        data: payload,
      );
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return <String, dynamic>{'data': response.data};
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.dio.get(ApiEndpoints.profile);
      return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.dio.post(ApiEndpoints.logout);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }
}
