import 'package:flutter/material.dart';
import 'package:my_tasks/models/subtask/subtask_model.dart';
import 'package:objectbox/objectbox.dart';

import '../../../database/objectbox_database.dart';

class SubtaskRepository extends ChangeNotifier {
  List<SubTask> _subtaskList = [];
  List<SubTask> get subtasks => _subtaskList;

  late final ObjectBoxDatabase _database;

  SubtaskRepository(this._database);

  Future<Box> getBox() async {
    final store = await _database.getStore();
    return store.box<SubTask>();
  }

  save(SubTask subtask) async {
    try {
      final box = await getBox();
      box.put(subtask);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error - $e");
      return false;
    }
  }

  getAll() async {
    final box = await getBox();
    _subtaskList = box.getAll() as List<SubTask>;
    notifyListeners();
  }
}
