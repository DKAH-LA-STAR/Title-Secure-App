import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/notary_exception_model.dart';

abstract class NotaryRepository {
  Future<List<NotaryExceptionModel>> getExceptions();
  Future<void> resolveException(
    int id, {
    required String resolutionNote,
    Map<String, dynamic>? extractedEntities,
    String status = 'verified',
  });
  Future<void> updateTitleValidity(int id, {required String validityStatus});
}

class NotaryRepositoryImpl implements NotaryRepository {
  final ApiClient apiClient;

  NotaryRepositoryImpl({required this.apiClient});

  @override
  Future<List<NotaryExceptionModel>> getExceptions() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.notaryExceptions,
      );

      List<dynamic> list = [];
      if (response is List) {
        list = response;
      } else if (response is Map<String, dynamic>) {
        list = (response['data'] as List?) ?? (response['exceptions'] as List?) ?? [];
      }

      return list
          .map((item) => NotaryExceptionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message']?.toString() ?? 'Failed to load notary exceptions',
        e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> resolveException(
    int id, {
    required String resolutionNote,
    Map<String, dynamic>? extractedEntities,
    String status = 'verified',
  }) async {
    try {
      await apiClient.put(
        ApiEndpoints.notaryResolveException(id),
        body: {
          'extracted_entities': extractedEntities ?? {'resolution_note': resolutionNote},
          'status': status,
        },
      );
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message']?.toString() ?? 'Failed to resolve exception',
        e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> updateTitleValidity(int id, {required String validityStatus}) async {
    try {
      await apiClient.put(
        ApiEndpoints.notaryValidity(id),
        body: {'validity_status': validityStatus},
      );
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message']?.toString() ?? 'Failed to update title validity',
        e.response?.statusCode,
      );
    }
  }
}
