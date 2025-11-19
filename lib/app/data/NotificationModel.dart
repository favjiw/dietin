// ignore_for_file: file_names

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime date;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
  });
}

class NotificationGroup {
  final String header;
  final List<NotificationModel> items;

  NotificationGroup({
    required this.header,
    required this.items,
  });
}
