import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/universal_back_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../../navigation/app_routes.dart';
import '../providers/ticket_provider.dart';

class TicketDetailScreen extends ConsumerStatefulWidget {
  const TicketDetailScreen({super.key, required this.ticketId});

  final String ticketId;

  @override
  ConsumerState<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends ConsumerState<TicketDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _sendComment() {
    final message = _commentController.text.trim();
    if (message.isEmpty) {
      return;
    }

    final author = ref.read(authStateProvider).user?.name ?? 'User';
    ref
        .read(ticketStateProvider.notifier)
        .addComment(
          ticketId: widget.ticketId,
          author: author,
          message: message,
        );

    ref
        .read(notificationStateProvider.notifier)
        .add(
          title: 'Komentar baru',
          body: '$author membalas #${widget.ticketId}.',
          route: AppRoutes.ticketDetailPath(widget.ticketId),
        );
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final ticket = ref.watch(
      ticketStateProvider.select((state) => state.ticketById(widget.ticketId)),
    );

    if (ticket == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Ticket')),
        body: const AppEmptyView(message: 'Ticket tidak ditemukan.'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const UniversalBackButton(),
        title: Text('#${ticket.id}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(ticket.title),
              subtitle: Text(ticket.description),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Status'),
              subtitle: Text(ticket.status),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Requester'),
              subtitle: Text(ticket.requester),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              title: const Text('Assignee'),
              subtitle: Text(ticket.assignee),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.schedule_outlined),
              title: const Text('Dibuat pada'),
              subtitle: Text(ticket.createdAt),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lampiran',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (ticket.attachments.isEmpty)
                    const Text('Tidak ada lampiran.')
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ticket.attachments
                          .map((item) => Chip(label: Text(item)))
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tracking',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...ticket.tracking.map((event) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.timeline_outlined),
                      title: Text(event.label),
                      subtitle: Text('${event.note}\n${event.createdAt}'),
                    );
                  }),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Komentar',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (ticket.comments.isEmpty)
                    const Text('Belum ada komentar.')
                  else
                    ...ticket.comments.map((comment) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.forum_outlined),
                        title: Text(comment.author),
                        subtitle: Text(
                          '${comment.message}\n${comment.createdAt}',
                        ),
                      );
                    }),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Tulis komentar / reply...',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: _sendComment,
                      icon: const Icon(Icons.send_outlined),
                      label: const Text('Kirim'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
