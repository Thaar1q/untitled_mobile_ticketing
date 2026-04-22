import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock/mock_ticket_data.dart';
import '../../data/models/ticket_item.dart';

class TicketState {
  const TicketState({
    required this.allTickets,
    required this.visibleCount,
    required this.loadingMore,
  });

  final List<TicketItem> allTickets;
  final int visibleCount;
  final bool loadingMore;

  static const int pageSize = 6;

  List<TicketItem> get visibleTickets {
    final end = visibleCount > allTickets.length
        ? allTickets.length
        : visibleCount;
    return allTickets.sublist(0, end);
  }

  bool get hasMore => visibleCount < allTickets.length;

  TicketItem? ticketById(String ticketId) {
    for (final ticket in allTickets) {
      if (ticket.id == ticketId) {
        return ticket;
      }
    }
    return null;
  }

  TicketState copyWith({
    List<TicketItem>? allTickets,
    int? visibleCount,
    bool? loadingMore,
  }) {
    return TicketState(
      allTickets: allTickets ?? this.allTickets,
      visibleCount: visibleCount ?? this.visibleCount,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }
}

class TicketNotifier extends StateNotifier<TicketState> {
  TicketNotifier()
    : super(
        TicketState(
          allTickets: MockTicketData.initialTickets(),
          visibleCount: TicketState.pageSize,
          loadingMore: false,
        ),
      );

  Future<void> loadMore() async {
    if (!state.hasMore || state.loadingMore) {
      return;
    }

    state = state.copyWith(loadingMore: true);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final nextCount = state.visibleCount + TicketState.pageSize;
    state = state.copyWith(visibleCount: nextCount, loadingMore: false);
  }

  void resetPagination() {
    state = state.copyWith(
      visibleCount: TicketState.pageSize,
      loadingMore: false,
    );
  }

  TicketItem createTicket({
    required String title,
    required String description,
    required String requester,
    required String attachmentSource,
  }) {
    final sequence = 2400 + state.allTickets.length + 1;
    final createdAt = _nowLabel();
    final newTicket = TicketItem(
      id: 'TK-$sequence',
      title: title.trim(),
      description: description.trim(),
      status: 'Open',
      requester: requester,
      assignee: '-',
      createdAt: createdAt,
      attachments: attachmentSource.isEmpty ? const [] : [attachmentSource],
      comments: const [],
      tracking: [
        TicketTrackingEvent(
          label: 'Ticket dibuat',
          note: 'Ticket baru dibuat melalui aplikasi mobile.',
          createdAt: createdAt,
        ),
        TicketTrackingEvent(
          label: 'Menunggu penanganan',
          note: 'Ticket menunggu assign helpdesk.',
          createdAt: createdAt,
        ),
      ],
    );

    final updated = [newTicket, ...state.allTickets];
    state = state.copyWith(
      allTickets: updated,
      visibleCount: state.visibleCount + 1,
    );
    return newTicket;
  }

  void addComment({
    required String ticketId,
    required String author,
    required String message,
  }) {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      return;
    }

    final now = _nowLabel();
    final updated = state.allTickets.map((ticket) {
      if (ticket.id != ticketId) {
        return ticket;
      }

      final comment = TicketComment(
        id: 'C-${ticket.id}-${ticket.comments.length + 1}',
        author: author,
        message: trimmedMessage,
        createdAt: now,
      );

      final tracking = [
        ...ticket.tracking,
        TicketTrackingEvent(
          label: 'Komentar baru',
          note: '$author menambahkan komentar.',
          createdAt: now,
        ),
      ];

      return ticket.copyWith(
        comments: [...ticket.comments, comment],
        tracking: tracking,
      );
    }).toList();

    state = state.copyWith(allTickets: updated);
  }

  void assignTicket({
    required String ticketId,
    required String assignee,
    required String actor,
  }) {
    final now = _nowLabel();
    final updated = state.allTickets.map((ticket) {
      if (ticket.id != ticketId) {
        return ticket;
      }

      final tracking = [
        ...ticket.tracking,
        TicketTrackingEvent(
          label: 'Di-assign',
          note: '$actor meng-assign ticket ke $assignee.',
          createdAt: now,
        ),
      ];

      return ticket.copyWith(assignee: assignee, tracking: tracking);
    }).toList();

    state = state.copyWith(allTickets: updated);
  }

  void updateStatus({
    required String ticketId,
    required String status,
    required String actor,
  }) {
    final now = _nowLabel();
    final updated = state.allTickets.map((ticket) {
      if (ticket.id != ticketId) {
        return ticket;
      }

      final label = status == 'Resolved' ? 'Selesai' : 'Status diperbarui';
      final tracking = [
        ...ticket.tracking,
        TicketTrackingEvent(
          label: label,
          note: '$actor mengubah status menjadi $status.',
          createdAt: now,
        ),
      ];

      return ticket.copyWith(status: status, tracking: tracking);
    }).toList();

    state = state.copyWith(allTickets: updated);
  }

  String _nowLabel() {
    final now = DateTime.now();
    final date =
        '${now.day.toString().padLeft(2, '0')} '
        '${_month(now.month)} '
        '${now.year}';
    final time =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }

  String _month(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month - 1];
  }
}

final ticketStateProvider = StateNotifierProvider<TicketNotifier, TicketState>(
  (ref) => TicketNotifier(),
);
