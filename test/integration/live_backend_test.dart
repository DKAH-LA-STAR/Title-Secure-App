import 'package:flutter_test/flutter_test.dart';
import 'package:title_secure/core/constants/api_endpoints.dart';
import 'package:title_secure/core/network/api_client.dart';
import 'package:title_secure/core/services/secure_storage.dart';
import 'package:title_secure/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:title_secure/features/auth/data/repositories/auth_repository.dart';
import 'package:title_secure/features/public/data/repositories/public_repository.dart';

void main() {
  group('Live Backend Integration Smoke Tests', () {
    late ApiClient apiClient;
    late SecureStorageService storageService;
    late AuthRepository authRepository;
    late PublicRepository publicRepository;

    setUp(() {
      storageService = InMemorySecureStorageService();
      apiClient = ApiClient(
        baseUrl: 'http://127.0.0.1:8000/api',
        storageService: storageService,
      );
      final remoteDataSource = AuthRemoteDataSourceImpl(apiClient: apiClient);
      authRepository = AuthRepositoryImpl(
        remoteDataSource: remoteDataSource,
        storageService: storageService,
      );
      publicRepository = PublicRepositoryImpl(apiClient: apiClient);
    });

    test('fetches public stats from live backend successfully', () async {
      final response = await apiClient.get(ApiEndpoints.publicStats);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['system_status'], equals('operational'));
      expect(response['total_registered_titles'], isNonNegative);
    });

    test('verifies an authentic seeded land title', () async {
      final result = await publicRepository.verifyTitle(titleNumber: 'LT-YDE-2024-001');
      expect(result.titleNumber, equals('LT-YDE-2024-001'));
      expect(result.ownerName, equals('Amadou Bello'));
      expect(result.status, equals('valid'));
      expect(result.parcelReference, equals('PAR-YDE-789'));
    });

    test('registers a user, obtains Sanctum token, and verifies authenticated user', () async {
      final uniqueEmail = 'flutter_e2e_${DateTime.now().millisecondsSinceEpoch}@titlesecure.cm';
      final user = await authRepository.register(
        name: 'E2E Flutter Client',
        email: uniqueEmail,
        password: 'password123',
        passwordConfirmation: 'password123',
        role: 'client',
        phoneNumber: '+237690000000',
      );

      expect(user.email, equals(uniqueEmail));
      expect(user.role, equals('client'));

      // Token should be saved in secure storage
      final token = await storageService.getToken();
      expect(token, isNotNull);
      expect(token!.isNotEmpty, isTrue);

      // Authenticated current user endpoint check
      final currentUser = await authRepository.getCachedOrRemoteUser();
      expect(currentUser, isNotNull);
      expect(currentUser!.email, equals(uniqueEmail));

      // Authenticated dashboard stats check
      final statsResponse = await apiClient.get(ApiEndpoints.dashboardStats);
      expect(statsResponse, isA<Map<String, dynamic>>());
      expect(statsResponse.containsKey('total_users'), isTrue);
      expect(statsResponse['total_users'], isNonNegative);

      // Logout
      await authRepository.logout();
      final postLogoutToken = await storageService.getToken();
      expect(postLogoutToken, isNull);
    });
  });
}
