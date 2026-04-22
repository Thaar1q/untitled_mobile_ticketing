import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../navigation/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/universal_back_button.dart';
import '../../../tickets/presentation/providers/ticket_provider.dart';

class AdminTicketManagementScreen extends ConsumerStatefulWidget {
  const AdminTicketManagementScreen({super.key});

  @override
  ConsumerState<AdminTicketManagementScreen> createState() =>
      _AdminTicketManagementScreenState();
}

class _AdminTicketManagementScreenState
    extends ConsumerState<AdminTicketManagementScreen> {
  String _statusFilter = 'All';

  List<String> get _filters => const ['All', 'Open', 'In Progress', 'Resolved'];

  @override
  Widget build(BuildContext context) {
    final actor = ref.watch(authStateProvider).user?.name ?? 'Helpdesk';
    final allTickets = ref.watch(ticketStateProvider).allTickets;
    final tickets = _statusFilter == 'All'
        ? allTickets
        : allTickets.where((ticket) => ticket.status == _statusFilter).toList();

    return Scaffold(
      appBar: AppBar(
        leading: const UniversalBackButton(),
        title: const Text('Manajemen Ticket'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: DropdownButtonFormField<String>(
              initialValue: _statusFilter,
              decoration: const InputDecoration(labelText: 'Filter Status'),
              items: _filters
                  .map(
                    (status) =>
                        DropdownMenuItem(value: status, child: Text(status)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() => _statusFilter = value);
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: tickets.isEmpty
                ? const AppEmptyView(
                    message: 'Tidak ada ticket untuk filter ini.',
                  )
                : ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      return Card(
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: ListTile(
                          title: Text('#${ticket.id} • ${ticket.title}'),
                          subtitle: Text(
                            'Status: ${ticket.status} • PIC: ${ticket.assignee}',
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              final ticketNotifier = ref.read(
                                ticketStateProvider.notifier,
                              );
                              final notificationNotifier = ref.read(
                                notificationStateProvider.notifier,
                              );

                              if (value == 'assign_bayu') {
                                ticketNotifier.assignTicket(
                                  ticketId: ticket.id,
                                  assignee: 'Helpdesk',
                                  actor: actor,
                                );
                                notificationNotifier.add(
                                  title: 'Ticket di-assign',
                                  body:
                                      '#${ticket.id} di-assign ke Helpdesk.',
                                  route: AppRoutes.ticketDetailPath(ticket.id),
                                );
                              } else if (value == 'assign_lucy') {
                                ticketNotifier.assignTicket(
                                  ticketId: ticket.id,
                                  assignee: 'Admin',
                                  actor: actor,
                                );
                                notificationNotifier.add(
                                  title: 'Ticket di-assign',
                                  body:
                                      '#${ticket.id} di-assign ke Admin.',
                                  route: AppRoutes.ticketDetailPath(ticket.id),
                                );
                              } else if (value == 'status_open') {
                                ticketNotifier.updateStatus(
                                  ticketId: ticket.id,
                                  status: 'Open',
                                  actor: actor,
                                );
                                notificationNotifier.add(
                                  title: 'Status ticket berubah',
                                  body: '#${ticket.id} menjadi Open.',
                                  route: AppRoutes.ticketDetailPath(ticket.id),
                                );
                              } else if (value == 'status_progress') {
                                ticketNotifier.updateStatus(
                                  ticketId: ticket.id,
                                  status: 'In Progress',
                                  actor: actor,
                                );
                                notificationNotifier.add(
                                  title: 'Status ticket berubah',
                                  body: '#${ticket.id} menjadi In Progress.',
                                  route: AppRoutes.ticketDetailPath(ticket.id),
                                );
                              } else if (value == 'status_resolved') {
                                ticketNotifier.updateStatus(
                                  ticketId: ticket.id,
                                  status: 'Resolved',
                                  actor: actor,
                                );
                                notificationNotifier.add(
                                  title: 'Status ticket berubah',
                                  body: '#${ticket.id} menjadi Resolved.',
                                  route: AppRoutes.ticketDetailPath(ticket.id),
                                );
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Perubahan disimpan.'),
                                ),
                              );
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'assign_bayu',
                                child: Text('Assign Helpdesk'),
                              ),
                              PopupMenuItem(
                                value: 'assign_lucy',
                                child: Text('Assign Admin'),
                              ),
                              PopupMenuDivider(),
                              PopupMenuItem(
                                value: 'status_open',
                                child: Text('Set Open'),
                              ),
                              PopupMenuItem(
                                value: 'status_progress',
                                child: Text('Set In Progress'),
                              ),
                              PopupMenuItem(
                                value: 'status_resolved',
                                child: Text('Set Resolved'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
