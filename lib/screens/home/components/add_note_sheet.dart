// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:my_tasks/constants/colors.dart';
import 'package:my_tasks/models/task/repository/task_repository.dart';
import 'package:provider/provider.dart';

import '../../../models/task/task_model.dart';

class AddNoteSheet extends StatefulWidget {
  const AddNoteSheet({super.key, this.task});

  final Task? task;

  @override
  State<AddNoteSheet> createState() => _AddNoteSheetState(
      taskTitle: task?.title ?? "",
      editTask: task != null ? true : false,
      task: task);
}

class _AddNoteSheetState extends State<AddNoteSheet> {
  bool? editTask = false;
  Task? task;
  String? taskTitle = "";

  _AddNoteSheetState({this.taskTitle, this.editTask, this.task});

  save() async {
    if (editTask == false) {
      context.read<taskRepository>().save(taskTitle!);
    } else {
      task?.title = taskTitle!;
      context.read<taskRepository>().update(task!);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: const BoxDecoration(
          color: gray300,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  width: 54,
                  height: 12,
                  decoration: BoxDecoration(
                      color: gray100, borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: gray100,
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 120,
                              child: TextFormField(
                                maxLines: 2,
                                minLines: 1,
                                initialValue: taskTitle,
                                decoration: const InputDecoration(
                                    isCollapsed: true,
                                    hintText: "Nome da Tarefa",
                                    border: InputBorder.none),
                                onChanged: (value) {
                                  setState(() {
                                    taskTitle = value;
                                  });
                                },
                              ),
                            ),
                            Text(
                              task?.createdAt.toString() ?? "",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: gray500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: taskTitle!.isNotEmpty
                    ? () {
                        save();
                      }
                    : null,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                      gradient: LinearGradient(
                          colors: taskTitle!.isNotEmpty
                              ? [blue200, blue400]
                              : [gray300, gray500],
                          begin: Alignment.topLeft,
                          end: AlignmentDirectional.bottomEnd)),
                  child: const Icon(
                    Icons.add,
                    size: 40,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
