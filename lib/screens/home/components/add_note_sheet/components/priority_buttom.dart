import 'package:flutter/material.dart';
import 'package:my_tasks/models/task/task_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../constants/colors.dart';

class PriorityButtom extends StatelessWidget {
  const PriorityButtom(
      {super.key, required this.task, required this.updateTask});
  final Task task;
  final Function updateTask;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: task.priority != null
            ? task.priority!.length == 3
                ? 80
                : task.priority!.length > 3
                    ? task.priority!.length * 10 + 30
                    : 120
            : 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
        ),
        padding: const EdgeInsets.fromLTRB(30, 0, 8, 0),
        child: DropdownButton(
          underline: Container(),
          borderRadius: BorderRadius.circular(16),
          icon: Container(),
          isExpanded: true,
          hint: const Text(
            "Prioridade",
            style: TextStyle(color: gray900),
          ),
          items: const [
            DropdownMenuItem(
              value: "higth",
              child: Text("Alta"),
            ),
            DropdownMenuItem(
              value: "medium",
              child: Text("Média"),
            ),
            DropdownMenuItem(
              value: "low",
              child: Text("Baixa"),
            )
          ],
          value: task.priority,
          onChanged: (value) {
            updateTask(value);
          },
        ),
      ),
      Container(
          margin: const EdgeInsets.only(top: 6.0, left: 8.0),
          child: PhosphorIcon(
            PhosphorIcons.light.flag,
            size: 20,
          )),
    ]);
  }
}
