import 'package:flutter/material.dart';
import 'package:my_tasks/database/objectbox.g.dart';
import 'package:my_tasks/models/subtask/subtask_model.dart';

class SubtaskRepository extends ChangeNotifier {
  late final Box<SubTask> subtaskBox;

  SubtaskRepository._create(Store store) {
    subtaskBox = Box<SubTask>(store);
  }

  static Future<SubtaskRepository> create(Store store) async {
    return SubtaskRepository._create(store);
  }

  save(SubTask subtask) async {
    subtaskBox.put(subtask);
  }
}
