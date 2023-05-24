// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:my_tasks/constants/colors.dart';
import 'package:my_tasks/models/subtask/subtask_model.dart';
import 'package:my_tasks/models/task/repository/task_repository.dart';
import 'package:provider/provider.dart';

import '../../../../models/task/task_model.dart';
import 'components/do_at_buttons.dart';
import 'components/subtask_row.dart';

class AddNoteSheet extends StatefulWidget {
  const AddNoteSheet({super.key, this.task});

  final Task? task;

  @override
  State<AddNoteSheet> createState() => _AddNoteSheetState(
      editTask: task != null ? true : false, task: task ?? Task(title: ""));
}

class _AddNoteSheetState extends State<AddNoteSheet> {
  bool? editTask = false;
  Task task;
  final ScrollController _controller = ScrollController();
  _AddNoteSheetState({this.editTask, required this.task});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (task.subtasks.length > 1) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  save() async {
    await context.read<TaskRepository>().save(task);

    Navigator.of(context).pop();
  }

  addSubtask(SubTask subtask) {
    setState(() {
      task.subtasks.add(subtask);
      if (task.subtasks.length > 1) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  changeTime(DateTime dateTime) {
    setState(() {
      task.doAt = dateTime;
    });
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
                            Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              direction: Axis.vertical,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 120,
                                  child: TextFormField(
                                    maxLines: 2,
                                    minLines: 1,
                                    initialValue: task.title,
                                    style: const TextStyle(
                                        fontSize: 18, color: gray900),
                                    decoration: const InputDecoration(
                                      isCollapsed: true,
                                      hintText: "Nome da Tarefa",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        task.title = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 120,
                                  child: TextFormField(
                                    maxLines: 4,
                                    minLines: 1,
                                    initialValue: task.description,
                                    style: const TextStyle(
                                        fontSize: 14, color: gray900),
                                    decoration: const InputDecoration(
                                      isCollapsed: true,
                                      hintText: "Descrição...",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        task.description = value;
                                      });
                                    },
                                  ),
                                ),
                                if (task.subtasks.isNotEmpty)
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 60,
                                    height: 90,
                                    child: ListView(
                                      controller: _controller,
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      children: [
                                        for (var subtask in task.subtasks)
                                          SubtaskRow(
                                            subtask: subtask,
                                          )
                                      ],
                                    ),
                                  ),
                                SubtaskRow(
                                  addSubtask: addSubtask,
                                ),
                                if (editTask == true)
                                  Text(
                                    task.createdAtFormated.toString(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: gray500),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 32,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      DoAtButton(
                        task: task,
                        changeTime: changeTime,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: task.title.isNotEmpty
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
                          colors: task.title.isNotEmpty
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
