// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:my_tasks/models/subtask/repository/subtask_repository.dart';
import 'package:my_tasks/models/task/repository/task_repository.dart';
import 'package:my_tasks/screens/home/components/body/components/task_row.dart';
import 'package:my_tasks/utils/date_format.dart';
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
        task.doneAt = DateTime.now();
      } else {
        task.isDone = false;
        task.doneAt = null;
      }
    }

    await context.read<TaskRepository>().update(task);
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

              final isLateTask = tasks
                  .where((element) => Jiffy.parse(element.expiresOn.toString())
                          .isBefore(Jiffy.parseFromList([
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      ])))
                  .toList();

              final isTodayTask = tasks
                  .where((element) => Jiffy.parse(element.expiresOn.toString())
                          .isSame(Jiffy.parseFromList([
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      ])))
                  .toList();

              final lastDay = Jiffy.parse(tasks.last.expiresOn.toString())
                  .startOf(Unit.day);

              final totalDays = lastDay.diff(
                  Jiffy.parseFromList([
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day
                  ]),
                  unit: Unit.day,
                  asFloat: true);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
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
                  Expanded(
                    child: ListView(
                      children: [
                        if (isLateTask.isNotEmpty)
                          InLastDays(
                              isLateTask: isLateTask,
                              updatedChecked: updatedChecked),
                        if (isTodayTask.isNotEmpty)
                          InToday(
                              isLateTask: isTodayTask,
                              updatedChecked: updatedChecked),
                        for (var day = 1; day <= totalDays; day++)
                          OthersDays(
                              tasks: tasks,
                              updatedChecked: updatedChecked,
                              day: day)
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class InLastDays extends StatelessWidget {
  const InLastDays(
      {super.key, required this.isLateTask, required this.updatedChecked});

  final List<Task> isLateTask;
  final Function updatedChecked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Atrasados",
          style: TextStyle(fontSize: 18),
        ),
        for (var task in isLateTask)
          taskRowWidget(task: task, updatedChecked: updatedChecked)
      ],
    );
  }
}

class InToday extends StatelessWidget {
  const InToday(
      {super.key, required this.isLateTask, required this.updatedChecked});

  final List<Task> isLateTask;
  final Function updatedChecked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hoje",
          style: TextStyle(fontSize: 18),
        ),
        for (var task in isLateTask)
          taskRowWidget(task: task, updatedChecked: updatedChecked)
      ],
    );
  }
}

class OthersDays extends StatelessWidget {
  const OthersDays(
      {super.key,
      required this.tasks,
      required this.updatedChecked,
      required this.day});

  final List<Task> tasks;
  final int day;
  final Function updatedChecked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateFormatToTomorrow(dateToShow: DateTime.now(), addDay: day),
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        for (var task in tasks)
          if (Jiffy.parseFromList([
            task.expiresOn.year,
            task.expiresOn.month,
            task.expiresOn.day
          ]).isSame(Jiffy.parseFromList([
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day
          ]).add(days: day)))
            taskRowWidget(task: task, updatedChecked: updatedChecked)
      ],
    );
  }
}
