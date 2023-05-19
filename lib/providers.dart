import 'package:my_tasks/models/task/repository/task_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final providers = <SingleChildWidget>[
  ChangeNotifierProvider(create: (context) => taskRepository())
];
