import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/universal_back_button.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationStateProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const UniversalBackButton(),
        title: const Text('Notifikasi'),
        actions: [
          if (state.unreadCount > 0)
            TextButton(
              onPressed: () {
                ref.read(notificationStateProvider.notifier).markAllAsRead();
              },
              child: const Text('Read All'),
            ),
        ],
      ),
      body: state.items.isEmpty
          ? const AppEmptyView(message: 'Belum ada notifikasi.')
          : ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Card(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: ListTile(
                    onTap: () {
                      ref
                          .read(notificationStateProvider.notifier)
                          .markAsRead(item.id);
                      context.push(item.route);
                    },
                    leading: Icon(
                      item.isRead
                          ? Icons.notifications_none_outlined
                          : Icons.notifications_active,
                    ),
                    title: Text(item.title),
                    subtitle: Text('${item.body}\n${item.createdAt}'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
