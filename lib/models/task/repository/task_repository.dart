// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:my_tasks/models/task/task_model.dart';

import '../../../database/objectbox.g.dart';

class TaskRepository extends ChangeNotifier {
  late final Box<Task> taskBox;

  TaskRepository._create(Store store) {
    taskBox = Box<Task>(store);
  }

  static Future<TaskRepository> create(Store store) async {
    return TaskRepository._create(store);
  }

  save(Task task) async {
    taskBox.put(task);
  }

  Stream<List<Task>> getAll() {
    final builder = taskBox.query()..order(Task_.expiresOn);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }
}
