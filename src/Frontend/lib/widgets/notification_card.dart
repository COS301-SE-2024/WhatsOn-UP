
class AppNotification {
  final String message;

  final String eventId;
  final String userId;
  final String sentAt;

  final String notificationId;
  String? seenAt;
  final String notificationTypes;

  AppNotification({
    required this.message,

    required this.eventId,
    required this.userId,
    required this.sentAt,
    required this.notificationId,
    required this.notificationTypes,
    this.seenAt,
  });
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      message: json['message'],
      eventId: json['event_id'],
      userId: json['user_id'],
      sentAt: json['sent_at'],
      seenAt: json['seen_at'],
      notificationId: json['notification_id'],
      notificationTypes: json['notification_types']['name'],
    );
  }
  void markAsSeen() {
    seenAt = DateTime.now().toIso8601String();
  }
  @override
  String toString() {
    return 'Notification(message: $message, eventId: $eventId, userId: $userId, sentAt: $sentAt, notificationId: $notificationId, notificationTypes: $notificationTypes)';
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