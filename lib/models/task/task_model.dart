import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Task {
  int id;
  String title;
  String? description;
  bool isDone;
  bool isArchived;
  DateTime createdAt;

  Task(
      {this.id = 0,
      required this.title,
      this.description,
      this.isDone = false,
      this.isArchived = false,
      DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  String get createdAtFormated => DateFormat.jm().format(createdAt);
}
