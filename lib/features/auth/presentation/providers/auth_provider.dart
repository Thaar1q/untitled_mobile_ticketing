import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/mock_auth_repository.dart';
import '../../domain/models/app_user.dart';

class AuthState {
  const AuthState({
    required this.initialized,
    required this.loading,
    this.user,
    this.errorMessage,
    this.infoMessage,
  });

  const AuthState.uninitialized()
    : initialized = false,
      loading = true,
      user = null,
      errorMessage = null,
      infoMessage = null;

  const AuthState.unauthenticated()
    : initialized = true,
      loading = false,
      user = null,
      errorMessage = null,
      infoMessage = null;

  final bool initialized;
  final bool loading;
  final AppUser? user;
  final String? errorMessage;
  final String? infoMessage;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    bool? initialized,
    bool? loading,
    AppUser? user,
    bool clearUser = false,
    String? errorMessage,
    bool clearError = false,
    String? infoMessage,
    bool clearInfo = false,
  }) {
    return AuthState(
      initialized: initialized ?? this.initialized,
      loading: loading ?? this.loading,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      infoMessage: clearInfo ? null : (infoMessage ?? this.infoMessage),
    );
  }

  bool hasAnyRole(Set<UserRole> allowedRoles) {
    final currentUser = user;
    return currentUser != null && allowedRoles.contains(currentUser.role);
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => MockAuthRepository(),
);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authRepository) : super(const AuthState.uninitialized()) {
    initialize();
  }

  final AuthRepository _authRepository;

  Future<void> initialize() async {
    final restoredUser = await _authRepository.restoreSession();
    state = AuthState(
      initialized: true,
      loading: false,
      user: restoredUser,
      errorMessage: null,
      infoMessage: null,
    );
  }

  Future<bool> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    state = state.copyWith(
      loading: true,
      clearError: true,
      clearInfo: true,
      clearUser: true,
    );

    final result = await _authRepository.login(
      usernameOrEmail: usernameOrEmail,
      password: password,
    );

    if (!result.success) {
      state = state.copyWith(
        loading: false,
        errorMessage: result.message,
        clearInfo: true,
        clearUser: true,
      );
      return false;
    }

    state = state.copyWith(
      loading: false,
      user: result.user,
      clearError: true,
      infoMessage: result.message,
    );
    return true;
  }

  Future<bool> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(loading: true, clearError: true, clearInfo: true);

    final result = await _authRepository.registerUser(
      name: name,
      username: username,
      email: email,
      password: password,
    );

    if (!result.success) {
      state = state.copyWith(
        loading: false,
        errorMessage: result.message,
        clearInfo: true,
      );
      return false;
    }

    state = state.copyWith(
      loading: false,
      clearError: true,
      infoMessage: result.message,
    );
    return true;
  }

  Future<bool> requestPasswordReset({required String email}) async {
    state = state.copyWith(loading: true, clearError: true, clearInfo: true);

    final result = await _authRepository.requestPasswordReset(email: email);
    if (!result.success) {
      state = state.copyWith(
        loading: false,
        errorMessage: result.message,
        clearInfo: true,
      );
      return false;
    }

    state = state.copyWith(
      loading: false,
      clearError: true,
      infoMessage: result.message,
    );
    return true;
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState.unauthenticated();
  }

  void clearFeedback() {
    if (state.errorMessage == null && state.infoMessage == null) {
      return;
    }
    state = state.copyWith(clearError: true, clearInfo: true);
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(authRepositoryProvider)),
);
