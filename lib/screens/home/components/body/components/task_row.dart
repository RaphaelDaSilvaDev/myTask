// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:my_tasks/models/task/task_model.dart';

import '../../../../../constants/colors.dart';
import '../../open_bottom_sheet.dart';

class taskRowWidget extends StatelessWidget {
  var isChecked = false;
  final Task task;
  final Function updatedChecked;

  taskRowWidget({super.key, required this.task, required this.updatedChecked});
  @override
  Widget build(BuildContext context) {
    var isBeforeToday = Jiffy.parse(task.doAt != null
            ? task.doAt!.toString()
            : DateTime.now().toString())
        .isBefore(Jiffy.now()
            .startOf(Unit.day)
            .add(hours: 23, minutes: 59, seconds: 59));

    var isAfterToday = task.doAt != null &&
        Jiffy.parse(task.doAt.toString()).isBefore(Jiffy.now());

    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: ListTile(
        onTap: task.isDone
            ? null
            : () {
                openBottomSheet(
                    context: context,
                    task: task,
                    updatedChecked: updatedChecked);
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
                if (task.description != null && task.description!.isNotEmpty)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        task.description!,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: gray500),
                      ),
                    ),
                  ),
                Text(
                  task.doAt != null
                      ? isBeforeToday
                          ? Jiffy.parse(task.doAt.toString()).fromNow()
                          : Jiffy.parse(task.doAt.toString()).MMMMEEEEd
                      : "Sem Data para Expirar",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: isAfterToday ? red300 : gray500),
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
                task.finishedAt = DateTime.now();
                updatedChecked(task);
              },
            ),
          ),
        ),
      ),
    );
  }
}
