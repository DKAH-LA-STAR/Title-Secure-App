import '../models/dashboard_stats_model.dart';

abstract class DashboardRepository {
  Future<DashboardStatsModel> getStats();
}

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<DashboardStatsModel> getStats() async {
    // Simulated remote fetch delay
    await Future.delayed(const Duration(milliseconds: 500));
    return const DashboardStatsModel(
      totalUsers: 1240,
      activeSessions: 86,
      revenue: 12450.50,
    );
  }
}
