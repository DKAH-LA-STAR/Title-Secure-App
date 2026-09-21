import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/models/land_title_model.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class VerificationState {
  final bool isLoading;
  final LandTitleModel? result;
  final String? errorMessage;
  final bool isNotFound;

  const VerificationState({
    this.isLoading = false,
    this.result,
    this.errorMessage,
    this.isNotFound = false,
  });

  VerificationState copyWith({
    bool? isLoading,
    LandTitleModel? result,
    String? errorMessage,
    bool? isNotFound,
  }) {
    return VerificationState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      errorMessage: errorMessage,
      isNotFound: isNotFound ?? this.isNotFound,
    );
  }
}

class PlatformStats {
  final int totalTitles;
  final int totalVerifications;
  final String systemStatus;

  const PlatformStats({
    required this.totalTitles,
    required this.totalVerifications,
    required this.systemStatus,
  });

  factory PlatformStats.fromJson(Map<String, dynamic> json) {
    return PlatformStats(
      totalTitles: json['total_titles'] as int? ?? 0,
      totalVerifications: json['total_verifications'] as int? ?? 0,
      systemStatus: json['system_status'] as String? ?? 'online',
    );
  }
}

// ─── Verification Controller ──────────────────────────────────────────────────

class PublicVerificationController
    extends StateNotifier<VerificationState> {
  final ApiClient _apiClient;

  PublicVerificationController(this._apiClient)
      : super(const VerificationState());

  Future<void> verifyByTitleNumber(String titleNumber) async {
    if (titleNumber.trim().isEmpty) return;
    state = const VerificationState(isLoading: true);
    try {
      final data = await _apiClient.get(
        '${ApiEndpoints.publicVerifyTitle}/${titleNumber.trim()}',
      ) as Map<String, dynamic>;
      final title = LandTitleModel.fromJson(
          data['data'] as Map<String, dynamic>? ?? data);
      state = VerificationState(result: title);
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('404') || msg.contains('not found')) {
        state = const VerificationState(
          isNotFound: true,
          errorMessage: 'No title found with that number.',
        );
      } else {
        state = VerificationState(
          errorMessage: 'Verification failed. Please try again.',
        );
      }
    }
  }

  Future<void> verifyByQrHash(String qrHash) async {
    if (qrHash.trim().isEmpty) return;
    state = const VerificationState(isLoading: true);
    try {
      final data = await _apiClient.get(
        '${ApiEndpoints.publicVerifyQr}/$qrHash',
      ) as Map<String, dynamic>;
      final title = LandTitleModel.fromJson(
          data['data'] as Map<String, dynamic>? ?? data);
      state = VerificationState(result: title);
    } catch (e) {
      state = const VerificationState(
        isNotFound: true,
        errorMessage: 'QR code not recognized.',
      );
    }
  }

  void reset() => state = const VerificationState();
}

final publicVerificationControllerProvider = StateNotifierProvider<
    PublicVerificationController, VerificationState>((ref) {
  return PublicVerificationController(ref.watch(apiClientProvider));
});

// ─── Stats Controller ─────────────────────────────────────────────────────────

final platformStatsProvider =
    FutureProvider<PlatformStats>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final data =
      await apiClient.get(ApiEndpoints.publicStats) as Map<String, dynamic>;
  return PlatformStats.fromJson(
      data['data'] as Map<String, dynamic>? ?? data);
});
