import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/universal_back_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../../navigation/app_routes.dart';
import '../../../../providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).user;
    final isDark = ref.watch(themeModeProvider);
    final unreadCount = ref.watch(
      notificationStateProvider.select((state) => state.unreadCount),
    );

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: const AppEmptyView(message: 'Profil tidak tersedia.'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const UniversalBackButton(),
        title: const Text('Profil'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person_outline)),
              title: Text(user.name),
              subtitle: Text(user.email),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: const Text('Role'),
              subtitle: Text(user.displayRole),
            ),
          ),
          Card(
            child: SwitchListTile(
              value: isDark,
              onChanged: (_) =>
                  ref.read(themeModeProvider.notifier).toggleTheme(),
              title: const Text('Mode Gelap'),
              subtitle: const Text('Sinkron dengan tema aplikasi.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notifikasi'),
              subtitle: Text('Belum dibaca: $unreadCount'),
              onTap: () => context.push(AppRoutes.notifications),
            ),
          ),
        ],
      ),
    );
  }
}
