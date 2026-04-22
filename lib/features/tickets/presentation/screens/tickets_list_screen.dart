import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/universal_back_button.dart';
import '../../../../navigation/app_routes.dart';
import '../providers/ticket_provider.dart';

class TicketsListScreen extends ConsumerStatefulWidget {
  const TicketsListScreen({super.key});

  @override
  ConsumerState<TicketsListScreen> createState() => _TicketsListScreenState();
}

class _TicketsListScreenState extends ConsumerState<TicketsListScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(ticketStateProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketState = ref.watch(ticketStateProvider);
    final tickets = ticketState.visibleTickets;

    return Scaffold(
      appBar: AppBar(
        leading: const UniversalBackButton(),
        title: const Text('Daftar Ticket'),
      ),
      body: tickets.isEmpty
          ? const AppEmptyView(message: 'Belum ada ticket.')
          : ListView.builder(
              controller: _scrollController,
              itemCount: tickets.length + (ticketState.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= tickets.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final ticket = tickets[index];
                return Card(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: ListTile(
                    onTap: () =>
                        context.push(AppRoutes.ticketDetailPath(ticket.id)),
                    leading: const Icon(Icons.confirmation_number_outlined),
                    title: Text('#${ticket.id}'),
                    subtitle: Text(ticket.title),
                    trailing: Text(ticket.status),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createTicket),
        icon: const Icon(Icons.add),
        label: const Text('Buat Ticket'),
      ),
    );
  }
}
