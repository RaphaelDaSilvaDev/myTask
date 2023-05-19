// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:my_tasks/database/objectbox_database.dart';
import 'package:my_tasks/models/task/task_model.dart';

import '../../../database/objectbox.g.dart';

class TaskRepository extends ChangeNotifier {
  List<Task> _taskList = [];
  List<Task> get tasks => _taskList;

  late final ObjectBoxDatabase _database;

  TaskRepository(this._database);

  Future<Box> getBox() async {
    final store = await _database.getStore();
    return store.box<Task>();
  }

  save(Task task) async {
    final newTask = Task(title: task.title, description: task.description);
    final box = await getBox();
    box.put(newTask);
    tasks.add(newTask);
    notifyListeners();
  }

  update(Task task) async {
    final box = await getBox();
    box.put(task);
    /*  final newTask = Task(
        title: task.title,
        id: task.id,
        createdAt: task.createdAt,
        isDone: task.isDone);
    tasks.replaceRange(tasks.indexOf(task), tasks.indexOf(task) + 1, [newTask]); */
    notifyListeners();
  }

  getAll() async {
    final box = await getBox();
    _taskList = box.getAll() as List<Task>;
    notifyListeners();
  }
}
