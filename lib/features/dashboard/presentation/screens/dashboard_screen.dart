import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/domain/models/app_user.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../../navigation/app_routes.dart';
import '../../../../providers/theme_provider.dart';
import '../../../tickets/presentation/providers/ticket_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider);
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final tickets = ref.watch(ticketStateProvider).allTickets;
    final unreadCount = ref.watch(
      notificationStateProvider.select((state) => state.unreadCount),
    );
    final openCount = tickets.where((ticket) => ticket.status == 'Open').length;
    final progressCount = tickets
        .where((ticket) => ticket.status == 'In Progress')
        .length;
    final resolvedCount = tickets
        .where((ticket) => ticket.status == 'Resolved')
        .length;
    final gradients = AppConstants.dashboardGradients;
    final stats = [
      _TicketStat('Total Ticket', tickets.length, Icons.confirmation_number),
      _TicketStat('Open', openCount, Icons.pending_actions_outlined),
      _TicketStat('In Progress', progressCount, Icons.build_circle_outlined),
      _TicketStat('Resolved', resolvedCount, Icons.task_alt_outlined),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Ticketing Helpdesk'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.notifications),
            tooltip: 'Notifikasi',
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_outlined),
                if (unreadCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : '$unreadCount',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, ${user?.name ?? 'Guest'}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Text(
                        ' ${user?.displayRole ?? '-'}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.sectionGap),
              Wrap(
                spacing: AppConstants.paddingSmall,
                runSpacing: AppConstants.paddingSmall,
                children: [
                  FilledButton.icon(
                    onPressed: () => context.push(AppRoutes.tickets),
                    icon: const Icon(Icons.list_alt_outlined),
                    label: const Text('Daftar Ticket'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.push(AppRoutes.createTicket),
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Buat Ticket'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.push(AppRoutes.profile),
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Profil'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.push(AppRoutes.notifications),
                    icon: const Icon(Icons.notifications_outlined),
                    label: Text('Notifikasi ($unreadCount)'),
                  ),
                  if (authState.hasAnyRole({UserRole.helpdesk, UserRole.admin}))
                    FilledButton.tonalIcon(
                      onPressed: () => context.push(AppRoutes.adminTickets),
                      icon: const Icon(Icons.manage_accounts_outlined),
                      label: const Text('Manajemen Ticket'),
                    ),
                ],
              ),
              const SizedBox(height: AppConstants.sectionGap),
              Text(
                'Ringkasan Tiket',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              GridView.builder(
                itemCount: stats.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.sizeOf(context).width >= 900 ? 4 : 2,
                  mainAxisSpacing: AppConstants.paddingSmall,
                  crossAxisSpacing: AppConstants.paddingSmall,
                  childAspectRatio: MediaQuery.sizeOf(context).width >= 900 ? 2.0 : 1.55,
                ),
                itemBuilder: (context, index) {
                  final item = stats[index];
                  final gradient = gradients[index % gradients.length];
                  return Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(item.icon, color: Colors.white),
                        const SizedBox(width: AppConstants.paddingSmall),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.white),
                              ),
                              Text(
                                '${item.value}',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppConstants.sectionGap),
              Text(
                'Ticket Terbaru',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              ...tickets.take(3).map((ticket) {
                return Card(
                  child: ListTile(
                    onTap: () => context.push(AppRoutes.ticketDetailPath(ticket.id)),
                    title: Text('#${ticket.id}'),
                    subtitle: Text(ticket.title),
                    trailing: Text(ticket.status),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketStat {
  const _TicketStat(this.title, this.value, this.icon);

  final String title;
  final int value;
  final IconData icon;
}
