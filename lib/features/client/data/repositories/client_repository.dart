import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/client_request_model.dart';

abstract class ClientRepository {
  Future<ClientRequestModel> submitRequest({
    required String titleNumber,
    required String ownerName,
    required String parcelReference,
    String? location,
    String? filePath,
  });

  Future<ClientRequestModel> trackRequest(String trackingCode);
  Future<String?> getCertificate(int id);
}

class ClientRepositoryImpl implements ClientRepository {
  final ApiClient apiClient;

  ClientRepositoryImpl({required this.apiClient});

  @override
  Future<ClientRequestModel> submitRequest({
    required String titleNumber,
    required String ownerName,
    required String parcelReference,
    String? location,
    String? filePath,
  }) async {
    try {
      final Map<String, dynamic> formMap = {
        'title_number': titleNumber,
        'owner_name': ownerName,
        'parcel_reference': parcelReference,
        if (location != null && location.isNotEmpty) 'location': location,
      };

      if (filePath != null && filePath.isNotEmpty) {
        final fileName = filePath.split('/').last;
        formMap['documents'] = [
          await MultipartFile.fromFile(
            filePath,
            filename: fileName,
          ),
        ];
      }

      final formData = FormData.fromMap(formMap);

      final response = await apiClient.post(
        ApiEndpoints.clientRequests,
        body: formData,
      );

      final Map<String, dynamic> responseMap = response is Map<String, dynamic>
          ? response
          : (response.data as Map<String, dynamic>);

      return ClientRequestModel.fromJson(responseMap);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      String message = 'Failed to submit verification request';
      if (responseData is Map<String, dynamic>) {
        message = responseData['message']?.toString() ??
            responseData['error']?.toString() ??
            message;
      } else if (e.message != null) {
        message = e.message!;
      }
      throw ApiException(message, e.response?.statusCode);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Submission error: ${e.toString()}');
    }
  }

  @override
  Future<ClientRequestModel> trackRequest(String trackingCode) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.clientTrack(trackingCode),
      );

      final Map<String, dynamic> responseMap = response is Map<String, dynamic>
          ? response
          : (response.data as Map<String, dynamic>);

      return ClientRequestModel.fromJson(responseMap);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      String message = 'Failed to track request';
      if (responseData is Map<String, dynamic>) {
        message = responseData['message']?.toString() ??
            responseData['error']?.toString() ??
            message;
      } else if (e.message != null) {
        message = e.message!;
      }
      throw ApiException(message, e.response?.statusCode);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Tracking error: ${e.toString()}');
    }
  }

  @override
  Future<String?> getCertificate(int id) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.clientCertificate(id),
      );
      if (response is Map<String, dynamic>) {
        return response['certificate_url']?.toString();
      }
      return null;
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message']?.toString() ?? 'Failed to fetch certificate',
        e.response?.statusCode,
      );
    }
  }
}
