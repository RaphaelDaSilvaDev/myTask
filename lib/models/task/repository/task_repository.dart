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
    try {
      final box = await getBox();
      box.put(task);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error - $e");
      return false;
    }
  }

  getAll() async {
    final box = await getBox();
    //_taskList = box.getAll().sort() as List<Task>;
    final query = box.query().order(Task_.finishedAt).build();
    _taskList = query.find() as List<Task>;
    query.close();
    notifyListeners();
  }
}
