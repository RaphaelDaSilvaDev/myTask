// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_tasks/app.dart';
import 'package:my_tasks/database/store.dart';
import 'package:my_tasks/models/subtask/repository/subtask_repository.dart';
import 'package:my_tasks/providers.dart';
import 'package:provider/provider.dart';

import 'database/objectbox.g.dart';
import 'models/task/repository/task_repository.dart';

late Store store;
late TaskRepository taskRepository;
late SubtaskRepository subtaskRepository;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  store = await CreateStore.create();
  taskRepository = await TaskRepository.create(store);
  subtaskRepository = await SubtaskRepository.create(store);

  initializeDateFormatting("pt_BR", null).then(
    (_) => runApp(const App()),
  );
}
