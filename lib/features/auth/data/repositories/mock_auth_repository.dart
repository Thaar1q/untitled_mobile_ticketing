import '../../../../core/services/app_preferences.dart';
import '../../domain/models/app_user.dart';
import 'auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository();

  static const List<_AuthAccount> _seedAccounts = [
    _AuthAccount(
      user: AppUser(
        id: 'U-001',
        name: 'User',
        username: 'user',
        email: 'user@company.local',
        role: UserRole.user,
      ),
      password: '12345678',
    ),
    _AuthAccount(
      user: AppUser(
        id: 'H-001',
        name: 'Helpdesk',
        username: 'helpdesk',
        email: 'helpdesk@company.local',
        role: UserRole.helpdesk,
      ),
      password: '12345678',
    ),
    _AuthAccount(
      user: AppUser(
        id: 'A-001',
        name: 'Admin',
        username: 'admin',
        email: 'admin@company.local',
        role: UserRole.admin,
      ),
      password: '12345678',
    ),
  ];

  List<_AuthAccount> _customAccounts = const [];
  bool _customAccountsLoaded = false;

  Iterable<_AuthAccount> get _allAccounts sync* {
    yield* _seedAccounts;
    yield* _customAccounts;
  }

  Future<void> _ensureCustomAccountsLoaded() async {
    if (_customAccountsLoaded) {
      return;
    }

    final storedAccounts = await AppPreferences.getCustomAccounts();
    _customAccounts = storedAccounts.map(_AuthAccount.fromJson).toList();
    _customAccountsLoaded = true;
  }

  Future<void> _persistCustomAccounts() async {
    final serialized = _customAccounts
        .map((account) => account.toJson())
        .toList();
    await AppPreferences.setCustomAccounts(serialized);
  }

  _AuthAccount? _findAccountByIdentity(String usernameOrEmail) {
    final normalized = usernameOrEmail.trim().toLowerCase();
    if (normalized.isEmpty) {
      return null;
    }

    for (final account in _allAccounts) {
      final matchesUsername = account.user.username.toLowerCase() == normalized;
      final matchesEmail = account.user.email.toLowerCase() == normalized;
      if (matchesUsername || matchesEmail) {
        return account;
      }
    }
    return null;
  }

  bool _isUsernameTaken(String username) {
    final normalized = username.trim().toLowerCase();
    return _allAccounts.any(
      (account) => account.user.username.toLowerCase() == normalized,
    );
  }

  bool _isEmailTaken(String email) {
    final normalized = email.trim().toLowerCase();
    return _allAccounts.any(
      (account) => account.user.email.toLowerCase() == normalized,
    );
  }

  @override
  Future<AppUser?> restoreSession() async {
    await _ensureCustomAccountsLoaded();
    final sessionJson = await AppPreferences.getAuthSession();
    if (sessionJson == null) {
      return null;
    }

    final user = AppUser.fromJson(sessionJson);
    final existing = _findAccountByIdentity(user.username);
    return existing?.user;
  }

  @override
  Future<AuthResult> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    await _ensureCustomAccountsLoaded();

    final account = _findAccountByIdentity(usernameOrEmail);
    if (account == null) {
      return const AuthResult.failure(message: 'Akun tidak ditemukan.');
    }

    if (account.password != password.trim()) {
      return const AuthResult.failure(message: 'Password tidak sesuai.');
    }

    await AppPreferences.setAuthSession(account.user.toJson());
    return AuthResult.success(message: 'Login berhasil.', user: account.user);
  }

  @override
  Future<AuthResult> registerUser({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    await _ensureCustomAccountsLoaded();

    final normalizedUsername = username.trim().toLowerCase();
    final normalizedEmail = email.trim().toLowerCase();

    if (_isUsernameTaken(normalizedUsername)) {
      return const AuthResult.failure(message: 'Username sudah digunakan.');
    }

    if (_isEmailTaken(normalizedEmail)) {
      return const AuthResult.failure(message: 'Email sudah terdaftar.');
    }

    final newUser = AppUser(
      id: 'U-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      username: normalizedUsername,
      email: normalizedEmail,
      role: UserRole.user,
    );

    final account = _AuthAccount(user: newUser, password: password.trim());
    _customAccounts = [..._customAccounts, account];
    await _persistCustomAccounts();

    return const AuthResult.success(
      message: 'Akun berhasil dibuat. Silakan login.',
    );
  }

  @override
  Future<AuthResult> requestPasswordReset({required String email}) async {
    await _ensureCustomAccountsLoaded();

    final normalizedEmail = email.trim().toLowerCase();
    final exists = _allAccounts.any(
      (account) => account.user.email.toLowerCase() == normalizedEmail,
    );

    if (!exists) {
      return const AuthResult.failure(message: 'Email tidak terdaftar.');
    }

    return const AuthResult.success(
      message: 'Link reset password terkirim (simulasi).',
    );
  }

  @override
  Future<void> logout() async {
    await AppPreferences.clearAuthSession();
  }
}

class _AuthAccount {
  const _AuthAccount({required this.user, required this.password});

  final AppUser user;
  final String password;

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'password': password};
  }

  factory _AuthAccount.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final safeUserMap = userJson is Map
        ? Map<String, dynamic>.from(userJson)
        : <String, dynamic>{};
    return _AuthAccount(
      user: AppUser.fromJson(safeUserMap),
      password: (json['password'] ?? '').toString(),
    );
  }
}
