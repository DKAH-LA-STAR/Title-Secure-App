import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../data/models/admin_models.dart';
import '../../data/repositories/admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

class AdminState {
  final bool isLoading;
  final bool isRunningCheck;
  final AdminStatsModel? stats;
  final List<DuplicateClaimModel> duplicates;
  final String? errorMessage;
  final String? successMessage;

  const AdminState({
    this.isLoading = false,
    this.isRunningCheck = false,
    this.stats,
    this.duplicates = const [],
    this.errorMessage,
    this.successMessage,
  });

  AdminState copyWith({
    bool? isLoading,
    bool? isRunningCheck,
    AdminStatsModel? stats,
    List<DuplicateClaimModel>? duplicates,
    String? errorMessage,
    String? successMessage,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      isRunningCheck: isRunningCheck ?? this.isRunningCheck,
      stats: stats ?? this.stats,
      duplicates: duplicates ?? this.duplicates,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class AdminController extends StateNotifier<AdminState> {
  final AdminRepository _repository;

  AdminController(this._repository) : super(const AdminState()) {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      final statsFuture = _repository.getStatistics();
      final duplicatesFuture = _repository.getDuplicates();

      final results = await Future.wait([statsFuture, duplicatesFuture]);

      state = state.copyWith(
        isLoading: false,
        stats: results[0] as AdminStatsModel,
        duplicates: results[1] as List<DuplicateClaimModel>,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> runDetectionCheck() async {
    state = state.copyWith(isRunningCheck: true, errorMessage: null, successMessage: null);
    try {
      final res = await _repository.runDetectionCheck();
      final message = res['message']?.toString() ?? 'Duplicate detection check completed.';
      await loadDashboardData();
      state = state.copyWith(
        isRunningCheck: false,
        successMessage: message,
      );
    } catch (e) {
      state = state.copyWith(
        isRunningCheck: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}

final adminControllerProvider =
    StateNotifierProvider<AdminController, AdminState>((ref) {
  return AdminController(ref.watch(adminRepositoryProvider));
});
