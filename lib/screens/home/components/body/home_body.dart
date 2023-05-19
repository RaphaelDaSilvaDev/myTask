// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
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
  final taskList = taskRepository().tasks;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getFilterTodos();
      loading.value = false;
    });
  }

  getFilterTodos() async {
    await context.read<taskRepository>().getAll();
  }

  updatedChecked(Task task) async {
    await context.read<taskRepository>().update(task);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Flexible(
        child: ValueListenableBuilder(
          valueListenable: loading,
          builder: (context, load, _) =>
              Consumer<taskRepository>(builder: (context, repository, child) {
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
                      child: Image(image: AssetImage("assets/emptyvideo.gif"))),
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
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return taskRowWidget(
                            task: tasks[index],
                            updatedChecked: updatedChecked,
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemCount: repository.tasks.length),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
