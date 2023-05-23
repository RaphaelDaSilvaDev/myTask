// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';
import 'package:my_tasks/models/subtask/subtask_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Task {
  int id;
  String title;
  String? description;
  bool isDone;
  bool isArchived;
  final subtasks = ToMany<SubTask>();
  DateTime createdAt;
  DateTime? finishedAt;
  DateTime? doAt;

  Task(
      {this.id = 0,
      required this.title,
      this.description,
      this.isDone = false,
      this.isArchived = false,
      this.finishedAt,
      this.doAt,
      ToMany<SubTask>? subtasks,
      DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  String get createdAtFormated => DateFormat.jm().format(createdAt);
}
