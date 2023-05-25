// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:my_tasks/models/subtask/repository/subtask_repository.dart';
import 'package:my_tasks/models/task/repository/task_repository.dart';
import 'package:my_tasks/screens/home/components/body/components/task_row.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../models/task/task_model.dart';

class homeBodyWidget extends StatefulWidget {
  const homeBodyWidget({super.key});

  @override
  State<homeBodyWidget> createState() => _homeBodyWidgetState();
}

class _homeBodyWidgetState extends State<homeBodyWidget> {
  final loading = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getFilterTodos();
      loading.value = false;
    });
  }

  getFilterTodos() async {
    await context.read<TaskRepository>().getAll();
  }

  updatedChecked(Task task) async {
    if (task.subtasks.isNotEmpty) {
      for (var subtask in task.subtasks) {
        await context.read<SubtaskRepository>().save(subtask);
      }
      if (task.subtasks.where((element) => element.isDone == true).length ==
          task.subtasks.length) {
        task.isDone = true;
        task.finishedAt = DateTime.now();
      } else {
        task.isDone = false;
        task.finishedAt = null;
      }
    }

    await context.read<TaskRepository>().save(task);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Flexible(
        child: ValueListenableBuilder(
          valueListenable: loading,
          builder: (context, load, _) => Consumer<TaskRepository>(
            builder: (context, repository, child) {
              final tasks = repository.tasks;

              final isLateTask = tasks.where((element) =>
                  element.finishedAt != null &&
                  Jiffy.parseFromList([
                    element.finishedAt!.year,
                    element.finishedAt!.month,
                    element.finishedAt!.day
                  ]).isBefore(Jiffy.parseFromList([
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day
                  ])));

              final isTodayTask = tasks.where((element) =>
                  element.finishedAt != null &&
                  Jiffy.parseFromList([
                    element.finishedAt!.year,
                    element.finishedAt!.month,
                    element.finishedAt!.day
                  ]).isSame(Jiffy.parseFromList([
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day
                  ])));

              final firstWithDate = repository.tasks
                  .where((element) => element.finishedAt != null);
              final lastDay =
                  Jiffy.parse(firstWithDate.last.finishedAt.toString());

              final totalDays = lastDay.diff(
                  Jiffy.parseFromList([
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day
                  ]),
                  unit: Unit.day,
                  asFloat: true);

              if (load) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (tasks.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                        width: 230,
                        child:
                            Image(image: AssetImage("assets/emptyvideo.gif"))),
                    Center(
                      child: Text(
                        'A lista de tarefas está vazia :(',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: blue200,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: Text(
                        "${tasks.where((task) => task.isDone == true).length} feitas de ${tasks.length}",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: gray100),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 200,
                    child: RefreshIndicator(
                      onRefresh: () async {},
                      child: Column(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: ListView(
                              children: [
                                if (isLateTask.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Atrasados",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      for (var task in isLateTask)
                                        taskRowWidget(
                                            task: task,
                                            updatedChecked: updatedChecked)
                                    ],
                                  ),
                                if (isTodayTask.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Hoje",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      for (var task in isTodayTask)
                                        taskRowWidget(
                                            task: task,
                                            updatedChecked: updatedChecked)
                                    ],
                                  ),
                                for (var day = 1; day <= totalDays; day++)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Jiffy.parseFromList([
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day
                                        ]).add(days: day).yMd,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      for (var task in tasks)
                                        if (task.finishedAt != null &&
                                            Jiffy.parseFromList([
                                              task.finishedAt!.year,
                                              task.finishedAt!.month,
                                              task.finishedAt!.day
                                            ]).isSame(Jiffy.parseFromList([
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day
                                            ]).add(days: day)))
                                          taskRowWidget(
                                              task: task,
                                              updatedChecked: updatedChecked)
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
