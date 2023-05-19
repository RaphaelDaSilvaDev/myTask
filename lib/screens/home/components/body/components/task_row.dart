// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_tasks/models/task/task_model.dart';

import '../../../../../constants/colors.dart';
import '../../add_note_sheet.dart';

class taskRowWidget extends StatelessWidget {
  var isChecked = false;
  final Task task;
  final Function updatedChecked;

  taskRowWidget({super.key, required this.task, required this.updatedChecked});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: ListTile(
        onTap: task.isDone
            ? null
            : () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    useSafeArea: false,
                    isScrollControlled: true,
                    builder: (_) => AddNoteSheet(
                          task: task,
                        ));
              },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24))),
        tileColor: task.isDone ? gray10060 : gray100,
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: gray900),
                ),
                Text(
                  DateFormat.jm().format(task.createdAt),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: gray500),
                )
              ],
            ),
          ),
        ),
        trailing: Transform.scale(
          scale: 1.4,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
                color: gray300, borderRadius: BorderRadius.circular(6)),
            child: Checkbox(
              checkColor: gray100,
              fillColor: task.isDone
                  ? MaterialStateProperty.all(blue200)
                  : MaterialStateProperty.all(gray300),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              value: task.isDone,
              onChanged: (bool? value) {
                task.isDone = value!;
                updatedChecked(task);
              },
            ),
          ),
        ),
      ),
    );
  }
}
