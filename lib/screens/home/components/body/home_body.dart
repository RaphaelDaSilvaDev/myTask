// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:my_tasks/main.dart';
import 'package:my_tasks/widgets/task_row.dart';
import '../../../../models/task/task_model.dart';

class homeBodyWidget extends StatefulWidget {
  const homeBodyWidget({super.key});

  @override
  State<homeBodyWidget> createState() => _homeBodyWidgetState();
}

class _homeBodyWidgetState extends State<homeBodyWidget> {
  final loading = ValueNotifier(true);

  taskRowWidget Function(BuildContext, int) _itemBuilder(List<Task> tasks) {
    return (BuildContext context, int index) =>
        taskRowWidget(task: tasks[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Flexible(
        child: StreamBuilder<List<Task>>(
            stream: taskRepository.getAll(),
            builder: (context, snapshot) {
              if (snapshot.data?.isNotEmpty ?? false) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                    itemBuilder: _itemBuilder(snapshot.data ?? []));
              } else {
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
            }),
      ),
    );
  }
}
