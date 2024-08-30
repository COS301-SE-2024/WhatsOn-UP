import '../utils.dart';

class AppNotification {
  final String message;

  String? eventId;
  final String userId;
  final String sentAt;
  bool? eventInvite;
  final String notificationId;
  String? seenAt;
  final String notificationTypes;
  String referencedEvent;

  AppNotification({
    required this.message,
    required this.eventId,
    required this.userId,
    required this.sentAt,
    required this.notificationId,
    required this.notificationTypes,
    required this.referencedEvent,
    this.seenAt,
    this.eventInvite,
  });
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      message: json['message'],
      eventId: json['event_id'],
      userId: json['user_id'],
      sentAt: json['sent_at'],
      seenAt: json['seen_at'],
      referencedEvent: json['referenced_event'],
      notificationId: json['notification_id'],
      notificationTypes: json['notification_types']['name'],
      eventInvite: json['event_invitees'] != null
          ? json['event_invitees']['accepted']
          : null,
    );
  }
  void markAsSeen() {
    seenAt = formatDateTime(DateTime.now().toIso8601String());
  }

  @override
  String toString() {
    return 'Notification(message: $message, eventId: $eventId, userId: $userId, sentAt: $sentAt, notificationId: $notificationId, notificationTypes: $notificationTypes, seenAt: $seenAt, referencedEvent: $referencedEvent, eventInvite: $eventInvite)';
  }
}

// Notification notification = Notification(
//   message: "Event Reminder",
//   description: "Don't forget about the event tomorrow!",
//   eventId: "123",
//   userId: "456",
//   sentAt: "2024-07-31 10:00:00",
//   notificationId: "789",
//   notificationTypes: ["reminder", "event"],
// );
