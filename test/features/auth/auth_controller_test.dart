import 'package:flutter_test/flutter_test.dart';
import 'package:title_secure/features/auth/data/models/user_model.dart';
import 'package:title_secure/features/auth/data/repositories/auth_repository.dart';
import 'package:title_secure/features/auth/presentation/controllers/auth_controller.dart';

class FakeAuthRepository implements AuthRepository {
  UserModel? userToReturn;
  bool shouldThrow = false;
  String errorMessage = 'Error occurred';
  bool loggedOut = false;

  @override
  Future<UserModel?> getCachedOrRemoteUser() async {
    if (shouldThrow) throw Exception(errorMessage);
    return userToReturn;
  }

  @override
  Future<UserModel> login({required String email, required String password}) async {
    if (shouldThrow) throw Exception(errorMessage);
    return userToReturn ?? const UserModel(id: 1, email: 'test@example.com', name: 'Test User');
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
    if (shouldThrow) throw Exception(errorMessage);
    return userToReturn ?? UserModel(id: 2, email: email, name: name, role: role ?? "client");
  }

  @override
  Future<void> logout() async {
    loggedOut = true;
  }
}

void main() {
  late FakeAuthRepository fakeRepo;
  late AuthController controller;

  setUp(() {
    fakeRepo = FakeAuthRepository();
  });

  test('Initial state checks auth status and sets unauthenticated if no cached user', () async {
    fakeRepo.userToReturn = null;
    controller = AuthController(fakeRepo);

    expect(controller.state.status, AuthStatus.loading);
    await Future.microtask(() {});
    expect(controller.state.status, AuthStatus.unauthenticated);
    expect(controller.state.user, null);
  });

  test('Initial state sets authenticated when cached user exists', () async {
    const testUser = UserModel(id: 100, email: 'user@test.com', name: 'Existing User');
    fakeRepo.userToReturn = testUser;
    controller = AuthController(fakeRepo);

    await Future.microtask(() {});
    expect(controller.state.status, AuthStatus.authenticated);
    expect(controller.state.user, testUser);
  });

  test('login success updates state to authenticated with user', () async {
    fakeRepo.userToReturn = null;
    controller = AuthController(fakeRepo);
    await Future.microtask(() {});

    fakeRepo.userToReturn = const UserModel(id: 1, email: 'john@example.com', name: 'John Doe');
    await controller.login('john@example.com', 'password123');

    expect(controller.state.status, AuthStatus.authenticated);
    expect(controller.state.user?.email, 'john@example.com');
    expect(controller.state.errorMessage, null);
  });

  test('login failure updates state to error with message', () async {
    fakeRepo.userToReturn = null;
    controller = AuthController(fakeRepo);
    await Future.microtask(() {});

    fakeRepo.shouldThrow = true;
    fakeRepo.errorMessage = 'Invalid credentials';
    await controller.login('john@example.com', 'wrongpassword');

    expect(controller.state.status, AuthStatus.error);
    expect(controller.state.errorMessage, 'Invalid credentials');
  });

  test('register success updates state to authenticated', () async {
    fakeRepo.userToReturn = null;
    controller = AuthController(fakeRepo);
    await Future.microtask(() {});

    await controller.register(
      name: 'Alice',
      email: 'alice@example.com',
      password: 'password123',
      passwordConfirmation: 'password123',
    );

    expect(controller.state.status, AuthStatus.authenticated);
    expect(controller.state.user?.name, 'Alice');
  });

  test('logout clears user state and sets status to unauthenticated', () async {
    const testUser = UserModel(id: 1, email: 'test@test.com', name: 'Test');
    fakeRepo.userToReturn = testUser;
    controller = AuthController(fakeRepo);
    await Future.microtask(() {});

    await controller.logout();

    expect(fakeRepo.loggedOut, isTrue);
    expect(controller.state.status, AuthStatus.unauthenticated);
    expect(controller.state.user, null);
  });
}
