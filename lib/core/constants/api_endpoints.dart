abstract class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com/v1';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String refreshToken = '/auth/refresh';

  // Dashboard Endpoints
  static const String dashboardStats = '/dashboard/stats';
}
