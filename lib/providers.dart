import 'package:my_tasks/database/objectbox_database.dart';
import 'package:my_tasks/models/task/repository/task_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'models/subtask/repository/subtask_repository.dart';

final providers = <SingleChildWidget>[
  Provider<ObjectBoxDatabase>(
    create: (context) => ObjectBoxDatabase(),
  ),
  ChangeNotifierProvider<SubtaskRepository>(
      create: (context) => SubtaskRepository(context.read())),
  ChangeNotifierProvider<TaskRepository>(
      create: (context) => TaskRepository(context.read()))
];
