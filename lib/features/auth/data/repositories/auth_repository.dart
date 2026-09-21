import '../../../../core/services/secure_storage.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? role,
    String? phoneNumber,
  });
  Future<UserModel?> getCachedOrRemoteUser();
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService storageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final data = await remoteDataSource.login(
      email: email,
      password: password,
    );

    // Save token to secure storage defensively
    final token = (data['token'] ??
            data['access_token'] ??
            (data['data'] is Map
                ? (data['data']['token'] ?? data['data']['access_token'])
                : null))
        ?.toString();
    if (token != null && token.isNotEmpty) {
      await storageService.saveToken(token);
    }

    final userData = data['user'] ??
        (data['data'] is Map ? (data['data']['user'] ?? data['data']) : null);
    if (userData is Map<String, dynamic>) {
      return UserModel.fromJson(userData);
    }

    return UserModel(
      id: 0,
      name: email.split('@').first,
      email: email,
    );
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? role,
    String? phoneNumber,
  }) async {
    final data = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      role: role,
      phoneNumber: phoneNumber,
    );

    // Extract token defensively
    final token = (data['token'] ??
            data['access_token'] ??
            (data['data'] is Map
                ? (data['data']['token'] ?? data['data']['access_token'])
                : null))
        ?.toString();

    if (token != null && token.isNotEmpty) {
      await storageService.saveToken(token);
    } else {
      // If registration succeeded on backend but didn't return an auth token immediately,
      // log in to acquire the Sanctum token
      try {
        final loggedInUser = await login(email: email, password: password);
        return loggedInUser;
      } catch (_) {
        // Continue if login attempt fails
      }
    }

    final userData = data['user'] ??
        (data['data'] is Map ? (data['data']['user'] ?? data['data']) : null);
    if (userData is Map<String, dynamic>) {
      return UserModel.fromJson(userData);
    }

    return UserModel(
      id: 0,
      name: name,
      email: email,
      role: role ?? 'client',
      phoneNumber: phoneNumber,
    );
  }

  @override
  Future<UserModel?> getCachedOrRemoteUser() async {
    final token = await storageService.getToken();
    if (token == null) return null;

    try {
      return await remoteDataSource.getCurrentUser();
    } catch (_) {
      // Clear token if expired/invalid
      await storageService.deleteToken();
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } finally {
      await storageService.deleteToken();
    }
  }
}
