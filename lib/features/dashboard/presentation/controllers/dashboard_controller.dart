import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../data/repositories/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

final dashboardControllerProvider = ChangeNotifierProvider<DashboardController>((ref) {
  return DashboardController(repository: ref.watch(dashboardRepositoryProvider));
});

class DashboardController extends ChangeNotifier {
  final DashboardRepository repository;

  DashboardStatsModel? _stats;
  bool _isLoading = false;
  String? _error;

  DashboardController({required this.repository});

  DashboardStatsModel? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stats = await repository.getStats();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
