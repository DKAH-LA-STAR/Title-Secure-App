class ApiEndpoints {
  static const String _envBaseUrl = String.fromEnvironment('BASE_URL');
  static String? _resolvedBaseUrl;

  /// Base URL loaded from --dart-define or automatically resolved based on runtime platform.
  /// On Android physical devices with adb reverse and web/desktop, http://127.0.0.1:8000/api is used.
  /// On Android emulator without adb reverse, fallback to http://10.0.2.2:8000/api.
  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) {
      return _envBaseUrl;
    }
    if (_resolvedBaseUrl != null) {
      return _resolvedBaseUrl!;
    }
    return 'http://127.0.0.1:8000/api';
  }

  static void setBaseUrl(String url) {
    _resolvedBaseUrl = url;
  }

  // ─── Auth ────────────────────────────────────────────────────────────────
  static String get register => '$baseUrl/auth/register';
  static String get login => '$baseUrl/auth/login';
  static String get logout => '$baseUrl/auth/logout';
  static String get profile => '$baseUrl/auth/user';
  static String get forgotPassword => '$baseUrl/auth/forgot-password';

  // ─── Public & Visitor ────────────────────────────────────────────────────
  static String get publicStats => '$baseUrl/public/stats';
  static String get publicVerify => '$baseUrl/public/verify';
  static String get publicVerifyTitle => '$baseUrl/public/verify/title';
  static String get publicVerifyQr => '$baseUrl/public/verify/qr';

  // ─── Payments ────────────────────────────────────────────────────────────
  static String get paymentInit => '$baseUrl/payments/initialize';

  // ─── Dashboard ───────────────────────────────────────────────────────────
  static String get dashboardStats => '$baseUrl/dashboard/stats';

  // ─── Client ──────────────────────────────────────────────────────────────
  static String get clientRequests => '$baseUrl/client/requests';
  static String clientTrack(String code) => '$baseUrl/client/requests/$code';
  static String clientCertificate(int id) =>
      '$baseUrl/client/requests/$id/certificate';

  // ─── Land Titles (shared authenticated) ─────────────────────────────────
  static String get titles => '$baseUrl/titles';
  static String titleDetail(int id) => '$baseUrl/titles/$id';

  // ─── Land Agent ──────────────────────────────────────────────────────────
  static String get agentUpload => '$baseUrl/agent/extractions/upload';
  static String agentProcessOcr(int id) =>
      '$baseUrl/agent/extractions/$id/process-ocr';
  static String get agentExtractions => '$baseUrl/agent/extractions';

  // ─── Notary ──────────────────────────────────────────────────────────────
  static String get notaryExceptions => '$baseUrl/notary/exceptions';
  static String notaryResolveException(int id) =>
      '$baseUrl/notary/exceptions/$id/resolve';
  static String notaryValidity(int id) => '$baseUrl/notary/titles/$id/validity';

  // ─── Admin ───────────────────────────────────────────────────────────────
  static String get adminStats => '$baseUrl/admin/reports/statistics';
  static String get adminDuplicates => '$baseUrl/admin/detection/duplicates';
  static String get adminRunCheck => '$baseUrl/admin/detection/run-check';
  static String get adminBroadcastSms =>
      '$baseUrl/admin/notifications/broadcast-sms';
}
