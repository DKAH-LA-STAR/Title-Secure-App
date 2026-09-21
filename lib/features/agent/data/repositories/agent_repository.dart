import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/extraction_model.dart';

abstract class AgentRepository {
  Future<ExtractionModel> uploadExtraction(String filePath, {String? titleNumber});
  Future<ExtractionModel> processOcr(int id);
  Future<List<ExtractionModel>> getExtractions();
}

class AgentRepositoryImpl implements AgentRepository {
  final ApiClient apiClient;

  AgentRepositoryImpl({required this.apiClient});

  @override
  Future<ExtractionModel> uploadExtraction(String filePath, {String? titleNumber}) async {
    try {
      final fileName = filePath.split('/').last;
      final formData = FormData.fromMap({
        'files': [await MultipartFile.fromFile(filePath, filename: fileName)],
        if (titleNumber != null && titleNumber.isNotEmpty) 'title_number': titleNumber,
      });

      final response = await apiClient.post(
        ApiEndpoints.agentUpload,
        body: formData,
      );

      final Map<String, dynamic> responseMap = response is Map<String, dynamic>
          ? response
          : (response.data as Map<String, dynamic>);

      return ExtractionModel.fromJson(responseMap);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      String message = 'Failed to upload document for extraction';
      if (responseData is Map<String, dynamic>) {
        message = responseData['message']?.toString() ??
            responseData['error']?.toString() ??
            message;
      }
      throw ApiException(message, e.response?.statusCode);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Upload error: ${e.toString()}');
    }
  }

  @override
  Future<ExtractionModel> processOcr(int id) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.agentProcessOcr(id),
      );

      final Map<String, dynamic> responseMap = response is Map<String, dynamic>
          ? response
          : (response.data as Map<String, dynamic>);

      return ExtractionModel.fromJson(responseMap);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      String message = 'Failed to process OCR';
      if (responseData is Map<String, dynamic>) {
        message = responseData['message']?.toString() ??
            responseData['error']?.toString() ??
            message;
      }
      throw ApiException(message, e.response?.statusCode);
    }
  }

  @override
  Future<List<ExtractionModel>> getExtractions() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.agentExtractions,
      );

      List<dynamic> list = [];
      if (response is List) {
        list = response;
      } else if (response is Map<String, dynamic>) {
        list = (response['data'] as List?) ?? (response['extractions'] as List?) ?? [];
      }

      return list
          .map((item) => ExtractionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message']?.toString() ?? 'Failed to load extractions',
        e.response?.statusCode,
      );
    }
  }
}
