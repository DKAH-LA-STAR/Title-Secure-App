import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_stats_model.dart';

abstract class DashboardRepository {
  Future<DashboardStatsModel> getStats();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiClient? apiClient;

  DashboardRepositoryImpl({this.apiClient});

  @override
  Future<DashboardStatsModel> getStats() async {
    if (apiClient != null) {
      final response = await apiClient!.get(ApiEndpoints.dashboardStats);
      final Map<String, dynamic> data = response is Map<String, dynamic>
          ? (response['data'] as Map<String, dynamic>? ?? response)
          : (response.data as Map<String, dynamic>);
      return DashboardStatsModel.fromJson(data);
    }
    return const DashboardStatsModel(
      totalUsers: 0,
      activeSessions: 0,
      revenue: 0.0,
    );
  }
}
