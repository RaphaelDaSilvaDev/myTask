// ignore_for_file: depend_on_referenced_packages
import 'package:my_tasks/models/subtask/subtask_model.dart';
import 'package:my_tasks/models/workspace/workspace_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Task {
  int id;
  String title;
  String? description;
  bool isDone;
  bool isArchived;
  String? priority;
  String? difficulty;
  final subtasks = ToMany<SubTask>();
  final workspace = ToOne<Workspace>();
  DateTime createdAt;
  DateTime expiresOn;
  DateTime? alertOn;
  DateTime? doneAt;

  Task({
    this.id = 0,
    required this.title,
    this.description,
    this.isDone = false,
    this.isArchived = false,
    this.priority,
    this.difficulty,
    this.alertOn,
    this.doneAt,
    ToOne<Workspace>? workspace,
    ToMany<SubTask>? subtasks,
    DateTime? createdAt,
    DateTime? expiresOn,
  })  : expiresOn = expiresOn ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  bool setDone() {
    isDone = !isDone;
    if (isDone == true) {
      doneAt = DateTime.now();
    } else {
      doneAt = null;
    }
    return isDone;
  }
}
