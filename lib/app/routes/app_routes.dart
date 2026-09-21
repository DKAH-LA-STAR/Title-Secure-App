abstract class AppRoutes {
  static const String initial = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Public
  static const String verify = '/verify';

  // Client
  static const String clientDashboard = '/client/dashboard';
  static const String clientSubmit = '/client/submit';
  static const String clientTrack = '/client/track';
  static const String clientCertificate = '/client/certificate';
  static const String clientPayment = '/client/payment';

  // Agent
  static const String agentDashboard = '/agent/dashboard';
  static const String agentUpload = '/agent/upload';
  static const String agentExtractionDetail = '/agent/extraction-detail';

  // Notary
  static const String notaryDashboard = '/notary/dashboard';
  static const String notaryExceptions = '/notary/exceptions';
  static const String notaryValidity = '/notary/validity';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String adminDuplicates = '/admin/duplicates';
  static const String adminStatistics = '/admin/statistics';
  static const String adminBroadcastSms = '/admin/broadcast-sms';
}

