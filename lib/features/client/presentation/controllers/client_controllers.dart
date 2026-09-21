import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../data/models/client_request_model.dart';
import '../../data/repositories/client_repository.dart';

final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  return ClientRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

// Submit State & Controller
class ClientSubmitState {
  final bool isLoading;
  final ClientRequestModel? submittedRequest;
  final String? errorMessage;

  const ClientSubmitState({
    this.isLoading = false,
    this.submittedRequest,
    this.errorMessage,
  });

  ClientSubmitState copyWith({
    bool? isLoading,
    ClientRequestModel? submittedRequest,
    String? errorMessage,
  }) {
    return ClientSubmitState(
      isLoading: isLoading ?? this.isLoading,
      submittedRequest: submittedRequest ?? this.submittedRequest,
      errorMessage: errorMessage,
    );
  }
}

class ClientSubmitController extends StateNotifier<ClientSubmitState> {
  final ClientRepository _repository;

  ClientSubmitController(this._repository)
      : super(const ClientSubmitState());

  Future<ClientRequestModel?> submitRequest({
    required String titleNumber,
    required String ownerName,
    required String parcelReference,
    String? location,
    String? filePath,
  }) async {
    state = const ClientSubmitState(isLoading: true);
    try {
      final req = await _repository.submitRequest(
        titleNumber: titleNumber,
        ownerName: ownerName,
        parcelReference: parcelReference,
        location: location,
        filePath: filePath,
      );
      state = ClientSubmitState(isLoading: false, submittedRequest: req);
      return req;
    } catch (e) {
      state = ClientSubmitState(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return null;
    }
  }

  void reset() {
    state = const ClientSubmitState();
  }
}

final clientSubmitControllerProvider =
    StateNotifierProvider<ClientSubmitController, ClientSubmitState>((ref) {
  return ClientSubmitController(ref.watch(clientRepositoryProvider));
});

// Track State & Controller
class ClientTrackState {
  final bool isLoading;
  final ClientRequestModel? trackedRequest;
  final String? certificateUrl;
  final String? errorMessage;

  const ClientTrackState({
    this.isLoading = false,
    this.trackedRequest,
    this.certificateUrl,
    this.errorMessage,
  });

  ClientTrackState copyWith({
    bool? isLoading,
    ClientRequestModel? trackedRequest,
    String? certificateUrl,
    String? errorMessage,
  }) {
    return ClientTrackState(
      isLoading: isLoading ?? this.isLoading,
      trackedRequest: trackedRequest ?? this.trackedRequest,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      errorMessage: errorMessage,
    );
  }
}

class ClientTrackController extends StateNotifier<ClientTrackState> {
  final ClientRepository _repository;

  ClientTrackController(this._repository) : super(const ClientTrackState());

  Future<void> trackRequest(String trackingCode) async {
    if (trackingCode.trim().isEmpty) {
      state = const ClientTrackState(
        errorMessage: 'Please enter a valid tracking code',
      );
      return;
    }

    state = const ClientTrackState(isLoading: true);
    try {
      final req = await _repository.trackRequest(trackingCode.trim());
      String? certUrl;
      if (req.status == 'verified') {
        try {
          certUrl = await _repository.getCertificate(req.id);
        } catch (_) {}
      }
      state = ClientTrackState(
        isLoading: false,
        trackedRequest: req,
        certificateUrl: certUrl,
      );
    } catch (e) {
      state = ClientTrackState(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void reset() {
    state = const ClientTrackState();
  }
}

final clientTrackControllerProvider =
    StateNotifierProvider<ClientTrackController, ClientTrackState>((ref) {
  return ClientTrackController(ref.watch(clientRepositoryProvider));
});
