import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../data/models/extraction_model.dart';
import '../../data/repositories/agent_repository.dart';

final agentRepositoryProvider = Provider<AgentRepository>((ref) {
  return AgentRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

class AgentState {
  final bool isLoading;
  final int? processingOcrId;
  final List<ExtractionModel> extractions;
  final String? errorMessage;
  final String? successMessage;

  const AgentState({
    this.isLoading = false,
    this.processingOcrId,
    this.extractions = const [],
    this.errorMessage,
    this.successMessage,
  });

  AgentState copyWith({
    bool? isLoading,
    int? processingOcrId,
    List<ExtractionModel>? extractions,
    String? errorMessage,
    String? successMessage,
  }) {
    return AgentState(
      isLoading: isLoading ?? this.isLoading,
      processingOcrId: processingOcrId,
      extractions: extractions ?? this.extractions,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class AgentController extends StateNotifier<AgentState> {
  final AgentRepository _repository;

  AgentController(this._repository) : super(const AgentState()) {
    fetchExtractions();
  }

  Future<void> fetchExtractions() async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      final list = await _repository.getExtractions();
      state = state.copyWith(isLoading: false, extractions: list);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> uploadDocument(String filePath, {String? titleNumber}) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      final item = await _repository.uploadExtraction(filePath, titleNumber: titleNumber);
      final updatedList = [item, ...state.extractions];
      state = state.copyWith(
        isLoading: false,
        extractions: updatedList,
        successMessage: 'Document uploaded successfully (ID: ${item.id})',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> processOcr(int id) async {
    state = state.copyWith(processingOcrId: id, errorMessage: null, successMessage: null);
    try {
      final updatedItem = await _repository.processOcr(id);
      final list = state.extractions.map((e) => e.id == id ? updatedItem : e).toList();
      state = state.copyWith(
        processingOcrId: null,
        extractions: list,
        successMessage: 'OCR processing completed for item #$id',
      );
    } catch (e) {
      state = state.copyWith(
        processingOcrId: null,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}

final agentControllerProvider =
    StateNotifierProvider<AgentController, AgentState>((ref) {
  return AgentController(ref.watch(agentRepositoryProvider));
});
