import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/admin_models.dart';

abstract class AdminRepository {
  Future<AdminStatsModel> getStatistics();
  Future<List<DuplicateClaimModel>> getDuplicates();
  Future<Map<String, dynamic>> runDetectionCheck({
    int? landTitleId,
    int? verificationRequestId,
  });
  Future<Map<String, dynamic>> broadcastSms({
    required List<String> phoneNumbers,
    required String message,
  });
}

class AdminRepositoryImpl implements AdminRepository {
  final ApiClient apiClient;

  AdminRepositoryImpl({required this.apiClient});

  @override
  Future<AdminStatsModel> getStatistics() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.adminStats,
      );

      final Map<String, dynamic> responseMap = response is Map<String, dynamic>
          ? response
          : (response.data as Map<String, dynamic>);

      return AdminStatsModel.fromJson(responseMap);
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message']?.toString() ?? 'Failed to load admin statistics',
        e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<DuplicateClaimModel>> getDuplicates() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.adminDuplicates,
      );

      List<dynamic> list = [];
      if (response is List) {
        list = response;
      } else if (response is Map<String, dynamic>) {
        list = (response['data'] as List?) ?? (response['duplicates'] as List?) ?? [];
      }

      return list
          .map((item) => DuplicateClaimModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message']?.toString() ?? 'Failed to load duplicate claims',
        e.response?.statusCode,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> runDetectionCheck({
    int? landTitleId,
    int? verificationRequestId,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (landTitleId != null) body['land_title_id'] = landTitleId;
      if (verificationRequestId != null) body['verification_request_id'] = verificationRequestId;

      final response = await apiClient.post(
        ApiEndpoints.adminRunCheck,
        body: body.isNotEmpty ? body : null,
      );

      if (response is Map<String, dynamic>) {
        return response;
      }
      return {'message': 'Detection check executed successfully'};
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message']?.toString() ?? 'Failed to execute detection check',
        e.response?.statusCode,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> broadcastSms({
    required List<String> phoneNumbers,
    required String message,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.adminBroadcastSms,
        body: {
          'phone_numbers': phoneNumbers,
          'message': message,
        },
      );

      if (response is Map<String, dynamic>) {
        return response;
      }
      return {'message': 'SMS broadcast sent successfully'};
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message']?.toString() ?? 'Failed to send broadcast SMS',
        e.response?.statusCode,
      );
    }
  }
}
