import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/input_validators.dart';
import '../providers/auth_provider.dart';
import '../../../../navigation/app_routes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(authStateProvider.notifier).clearFeedback();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(authStateProvider.notifier)
        .login(
          usernameOrEmail: _usernameController.text,
          password: _passwordController.text,
        );

    if (!mounted) {
      return;
    }

    final latest = ref.read(authStateProvider);
    if (latest.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(latest.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Masuk ke E-Ticketing',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gunakan username/email dan password lokal.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const Key('login_username'),
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Username atau Email',
                    ),
                    validator: InputValidators.usernameOrEmail,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    key: const Key('login_password'),
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: InputValidators.password,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: authState.initialized && !authState.loading
                        ? _submit
                        : null,
                    child: Text(authState.loading ? 'Memproses...' : 'Masuk'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Demo akun:\n'
                    '- user / 12345678\n'
                    '- helpdesk / 12345678\n'
                    '- admin / 12345678',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (authState.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      authState.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => context.push(AppRoutes.register),
                        child: const Text('Daftar'),
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.resetPassword),
                        child: const Text('Lupa Password'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
