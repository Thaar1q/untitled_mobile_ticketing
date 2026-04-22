import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.route,
    required this.isRead,
  });

  final String id;
  final String title;
  final String body;
  final String createdAt;
  final String route;
  final bool isRead;

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? createdAt,
    String? route,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      route: route ?? this.route,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationState {
  const NotificationState({required this.items});

  final List<AppNotification> items;

  int get unreadCount => items.where((item) => !item.isRead).length;

  NotificationState copyWith({List<AppNotification>? items}) {
    return NotificationState(items: items ?? this.items);
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier()
    : super(
        const NotificationState(
          items: [
            AppNotification(
              id: 'N-001',
              title: 'Ticket diperbarui',
              body: '#TK-2402 sedang diproses helpdesk.',
              createdAt: '22 Apr 2026 09:20',
              route: '/tickets/TK-2402',
              isRead: false,
            ),
            AppNotification(
              id: 'N-002',
              title: 'Ticket selesai',
              body: '#TK-2403 ditandai selesai.',
              createdAt: '21 Apr 2026 17:12',
              route: '/tickets/TK-2403',
              isRead: true,
            ),
          ],
        ),
      );

  void add({
    required String title,
    required String body,
    required String route,
  }) {
    final next = AppNotification(
      id: 'N-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      body: body,
      createdAt: _nowLabel(),
      route: route,
      isRead: false,
    );
    state = state.copyWith(items: [next, ...state.items]);
  }

  void markAsRead(String notificationId) {
    state = state.copyWith(
      items: state.items
          .map(
            (item) =>
                item.id == notificationId ? item.copyWith(isRead: true) : item,
          )
          .toList(),
    );
  }

  void markAllAsRead() {
    state = state.copyWith(
      items: state.items.map((item) => item.copyWith(isRead: true)).toList(),
    );
  }

  String _nowLabel() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$day Apr ${now.year} $hour:$minute';
  }
}

final notificationStateProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
      (ref) => NotificationNotifier(),
    );
