import 'package:flutter/material.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../data/repositories/dashboard_repository.dart';

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
