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

    // Save token to secure storage
    final token = data['token'] as String;
    await storageService.saveToken(token);

    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final data = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    final token = data['token'] as String;
    await storageService.saveToken(token);

    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
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