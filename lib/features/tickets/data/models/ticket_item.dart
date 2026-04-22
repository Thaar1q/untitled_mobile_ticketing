class TicketItem {
  const TicketItem({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.requester,
    required this.assignee,
    required this.createdAt,
    required this.attachments,
    required this.comments,
    required this.tracking,
  });

  final String id;
  final String title;
  final String description;
  final String status;
  final String requester;
  final String assignee;
  final String createdAt;
  final List<String> attachments;
  final List<TicketComment> comments;
  final List<TicketTrackingEvent> tracking;

  TicketItem copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? requester,
    String? assignee,
    String? createdAt,
    List<String>? attachments,
    List<TicketComment>? comments,
    List<TicketTrackingEvent>? tracking,
  }) {
    return TicketItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      requester: requester ?? this.requester,
      assignee: assignee ?? this.assignee,
      createdAt: createdAt ?? this.createdAt,
      attachments: attachments ?? this.attachments,
      comments: comments ?? this.comments,
      tracking: tracking ?? this.tracking,
    );
  }
}

class TicketComment {
  const TicketComment({
    required this.id,
    required this.author,
    required this.message,
    required this.createdAt,
  });

  final String id;
  final String author;
  final String message;
  final String createdAt;
}

class TicketTrackingEvent {
  const TicketTrackingEvent({
    required this.label,
    required this.note,
    required this.createdAt,
  });

  final String label;
  final String note;
  final String createdAt;
}
