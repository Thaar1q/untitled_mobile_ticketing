import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_ticketing/features/auth/data/repositories/auth_repository.dart';
import 'package:mobile_ticketing/features/auth/domain/models/app_user.dart';
import 'package:mobile_ticketing/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_ticketing/main.dart';

void main() {
  final testAuthRepository = _TestAuthRepository();

  testWidgets('App routes from login to dashboard with hardcoded data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(testAuthRepository),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    expect(find.text('Masuk ke E-Ticketing'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('login_username')),
      'user',
    );
    await tester.enterText(
      find.byKey(const Key('login_password')),
      '123456',
    );
    await tester.tap(find.text('Masuk'));
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump();

    expect(find.text('E-Ticketing Helpdesk'), findsOneWidget);
    expect(find.text('Ringkasan Tiket'), findsOneWidget);
    expect(find.text('Total Ticket'), findsOneWidget);
    expect(find.text('Daftar Ticket'), findsOneWidget);
  });
}

class _TestAuthRepository implements AuthRepository {
  static const AppUser _user = AppUser(
    id: 'U-TEST-001',
    name: 'Test User',
    username: 'user',
    email: 'user@company.local',
    role: UserRole.user,
  );

  @override
  Future<AuthResult> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    final okIdentity = usernameOrEmail.trim().toLowerCase() == 'user';
    final okPassword = password.trim() == '123456';
    if (!okIdentity || !okPassword) {
      return const AuthResult.failure(message: 'Kredensial tidak valid.');
    }
    return const AuthResult.success(message: 'Login berhasil.', user: _user);
  }

  @override
  Future<AuthResult> registerUser({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    return const AuthResult.success(message: 'Akun berhasil dibuat.');
  }

  @override
  Future<AuthResult> requestPasswordReset({required String email}) async {
    return const AuthResult.success(message: 'Link reset terkirim.');
  }

  @override
  Future<AppUser?> restoreSession() async {
    return null;
  }

  @override
  Future<void> logout() async {}
}
