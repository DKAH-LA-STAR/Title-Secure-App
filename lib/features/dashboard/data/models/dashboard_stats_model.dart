class DashboardStatsModel {
  final int totalUsers;
  final int activeSessions;
  final double revenue;

  const DashboardStatsModel({
    required this.totalUsers,
    required this.activeSessions,
    required this.revenue,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalUsers: json['total_users'] as int? ?? 0,
      activeSessions: json['active_sessions'] as int? ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
