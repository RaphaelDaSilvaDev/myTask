// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:my_tasks/models/task/task_model.dart';

class taskRepository extends ChangeNotifier {
  List<Task> _taskList = [];

  List<Task> get tasks => _taskList;

  save(String title) async {
    final newTask = Task(title: title, createdAt: DateTime.now());
    tasks.add(newTask);
    notifyListeners();
  }

  update(Task task) async {
    final newTask = Task(
        title: task.title,
        id: task.id,
        createdAt: task.createdAt,
        isDone: task.isDone);
    tasks.replaceRange(tasks.indexOf(task), tasks.indexOf(task) + 1, [newTask]);
    notifyListeners();
  }

  getAll() async {
    _taskList = tasks;
    notifyListeners();
  }
}
