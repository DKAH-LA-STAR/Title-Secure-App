import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../data/models/verification_result_model.dart';
import '../../data/repositories/public_repository.dart';

final publicRepositoryProvider = Provider<PublicRepository>((ref) {
  return PublicRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

class VerificationState {
  final bool isLoading;
  final VerificationResultModel? result;
  final String? errorMessage;

  const VerificationState({
    this.isLoading = false,
    this.result,
    this.errorMessage,
  });

  VerificationState copyWith({
    bool? isLoading,
    VerificationResultModel? result,
    String? errorMessage,
  }) {
    return VerificationState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      errorMessage: errorMessage,
    );
  }
}

class VerificationController extends StateNotifier<VerificationState> {
  final PublicRepository _repository;

  VerificationController(this._repository) : super(const VerificationState());

  Future<void> verifyTitle({String? titleNumber, String? qrHash}) async {
    if ((titleNumber == null || titleNumber.trim().isEmpty) &&
        (qrHash == null || qrHash.trim().isEmpty)) {
      state = state.copyWith(
        errorMessage: 'Please enter a Title Number or QR Hash to verify',
      );
      return;
    }

    state = const VerificationState(isLoading: true);

    try {
      final res = await _repository.verifyTitle(
        titleNumber: titleNumber?.trim(),
        qrHash: qrHash?.trim(),
      );
      state = VerificationState(isLoading: false, result: res);
    } catch (e) {
      state = VerificationState(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void reset() {
    state = const VerificationState();
  }
}

final verificationControllerProvider =
    StateNotifierProvider<VerificationController, VerificationState>((ref) {
  return VerificationController(ref.watch(publicRepositoryProvider));
});
