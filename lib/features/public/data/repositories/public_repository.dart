import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/verification_result_model.dart';

abstract class PublicRepository {
  Future<VerificationResultModel> verifyTitle({
    String? titleNumber,
    String? qrHash,
  });
}

class PublicRepositoryImpl implements PublicRepository {
  final ApiClient apiClient;

  PublicRepositoryImpl({required this.apiClient});

  @override
  Future<VerificationResultModel> verifyTitle({
    String? titleNumber,
    String? qrHash,
  }) async {
    try {
      final payload = <String, dynamic>{};
      if (titleNumber != null && titleNumber.isNotEmpty) {
        payload['title_number'] = titleNumber;
      }
      if (qrHash != null && qrHash.isNotEmpty) {
        payload['qr_hash'] = qrHash;
      }

      final response = await apiClient.post(
        ApiEndpoints.publicVerify,
        body: payload,
      );

      final Map<String, dynamic> responseMap = response is Map<String, dynamic>
          ? response
          : (response.data as Map<String, dynamic>);

      return VerificationResultModel.fromJson(responseMap);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      String message = 'Failed to verify title';
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
      throw ApiException('Unexpected verification error: ${e.toString()}');
    }
  }
}
