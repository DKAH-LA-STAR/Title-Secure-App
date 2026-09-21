import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../data/models/notary_exception_model.dart';
import '../../data/repositories/notary_repository.dart';

final notaryRepositoryProvider = Provider<NotaryRepository>((ref) {
  return NotaryRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

class NotaryState {
  final bool isLoading;
  final int? actionId;
  final List<NotaryExceptionModel> exceptions;
  final String? errorMessage;
  final String? successMessage;

  const NotaryState({
    this.isLoading = false,
    this.actionId,
    this.exceptions = const [],
    this.errorMessage,
    this.successMessage,
  });

  NotaryState copyWith({
    bool? isLoading,
    int? actionId,
    List<NotaryExceptionModel>? exceptions,
    String? errorMessage,
    String? successMessage,
  }) {
    return NotaryState(
      isLoading: isLoading ?? this.isLoading,
      actionId: actionId,
      exceptions: exceptions ?? this.exceptions,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class NotaryController extends StateNotifier<NotaryState> {
  final NotaryRepository _repository;

  NotaryController(this._repository) : super(const NotaryState()) {
    fetchExceptions();
  }

  Future<void> fetchExceptions() async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      final list = await _repository.getExceptions();
      state = state.copyWith(isLoading: false, exceptions: list);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> resolveException(int id, String resolutionNote) async {
    state = state.copyWith(actionId: id, errorMessage: null, successMessage: null);
    try {
      await _repository.resolveException(id, resolutionNote: resolutionNote);
      final list = state.exceptions.where((item) => item.id != id).toList();
      state = state.copyWith(
        actionId: null,
        exceptions: list,
        successMessage: 'Exception #$id successfully resolved.',
      );
    } catch (e) {
      state = state.copyWith(
        actionId: null,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> updateValidity(int id, String validityStatus) async {
    state = state.copyWith(actionId: id, errorMessage: null, successMessage: null);
    try {
      await _repository.updateTitleValidity(id, validityStatus: validityStatus);
      await fetchExceptions();
      state = state.copyWith(
        actionId: null,
        successMessage: 'Title #$id validity updated to ${validityStatus.toUpperCase()}',
      );
    } catch (e) {
      state = state.copyWith(
        actionId: null,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}

final notaryControllerProvider =
    StateNotifierProvider<NotaryController, NotaryState>((ref) {
  return NotaryController(ref.watch(notaryRepositoryProvider));
});
