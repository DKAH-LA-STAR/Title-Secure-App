import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
}

class FlutterSecureStorageService implements SecureStorageService {
  final FlutterSecureStorage _storage;

  FlutterSecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}

class InMemorySecureStorageService implements SecureStorageService {
  String? _token;

  @override
  Future<void> saveToken(String token) async {
    _token = token;
  }

  @override
  Future<String?> getToken() async => _token;

  @override
  Future<void> deleteToken() async {
    _token = null;
  }
}
