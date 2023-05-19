import 'package:my_tasks/database/objectbox_database.dart';
import 'package:my_tasks/models/task/repository/task_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final providers = <SingleChildWidget>[
  Provider<ObjectBoxDatabase>(
    create: (context) => ObjectBoxDatabase(),
  ),
  ChangeNotifierProvider<TaskRepository>(
      create: (context) => TaskRepository(context.read()))
];
