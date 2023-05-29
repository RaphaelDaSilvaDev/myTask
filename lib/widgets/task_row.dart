// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:my_tasks/main.dart';
import 'package:my_tasks/models/task/task_model.dart';
import 'package:my_tasks/utils/date_format.dart';
import 'package:my_tasks/widgets/subtask_row.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/colors.dart';
import '../screens/home/components/open_bottom_sheet.dart';

class taskRowWidget extends StatefulWidget {
  final Task task;

  const taskRowWidget({super.key, required this.task});

  @override
  State<taskRowWidget> createState() => _taskRowWidgetState();
}

class _taskRowWidgetState extends State<taskRowWidget> {
  late bool isChecked;
  var isOpen = false;
  var turns = 0.0;

  void toggleIsDone() {
    bool newStatus = widget.task.setDone();

    taskRepository.taskBox.put(widget.task);

    setState(() {
      isChecked = newStatus;
    });
  }

  void checkAllSubtaskIsDone() {
    var getIsDone =
        widget.task.subtasks.where((element) => element.isDone == true);
    if (getIsDone.length == widget.task.subtasks.length) {
      toggleIsDone();
    } else if (getIsDone.length == widget.task.subtasks.length - 1 &&
        isChecked == true) {
      toggleIsDone();
    }
  }

  @override
  void initState() {
    isChecked = widget.task.isDone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isAfterToday =
        Jiffy.parse(widget.task.expiresOn.toString()).isBefore(Jiffy.now());

    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: ListTile(
        onTap: widget.task.isDone
            ? null
            : () {
                openBottomSheet(
                  context: context,
                  task: widget.task,
                );
              },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24))),
        tileColor: widget.task.isDone ? gray10060 : gray100,
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: gray900),
                ),
                if (widget.task.description != null &&
                    widget.task.description!.isNotEmpty)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 25,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        widget.task.description!,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: gray500),
                      ),
                    ),
                  ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: isOpen
                      ? widget.task.subtasks.length * 40 <= 160
                          ? widget.task.subtasks.length * 40
                          : 160
                      : 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: isOpen
                        ? widget.task.subtasks.length * 40 <= 160
                            ? widget.task.subtasks.length * 40
                            : 160
                        : 0,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.task.subtasks.length,
                      itemBuilder: (context, index) {
                        return SubTaskRow(
                          subtask: widget.task.subtasks[index],
                          verifyAllSubtaskIsDone: checkAllSubtaskIsDone,
                        );
                      },
                    ),
                  ),
                ),
                if (Jiffy.now().startOf(Unit.day).isAfter(
                    Jiffy.parse(widget.task.expiresOn.toString())
                        .startOf(Unit.day)))
                  Text(
                    dateFormatReturnHours(dateToShow: widget.task.expiresOn),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: isAfterToday ? red300 : gray500),
                  )
              ],
            ),
          ),
        ),
        trailing: widget.task.subtasks.isEmpty
            ? Transform.scale(
                scale: 1.4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                      color: gray300, borderRadius: BorderRadius.circular(6)),
                  child: Checkbox(
                    checkColor: gray100,
                    fillColor: widget.task.isDone
                        ? MaterialStateProperty.all(blue200)
                        : MaterialStateProperty.all(gray300),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    value: isChecked,
                    onChanged: (bool? value) {
                      toggleIsDone();
                    },
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 10),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isOpen = !isOpen;
                        isOpen ? turns -= 1 / 2 : turns += 1 / 2;
                      });
                    },
                    child: AnimatedRotation(
                        turns: turns,
                        duration: const Duration(milliseconds: 200),
                        child: PhosphorIcon(PhosphorIcons.light.caretDown)),
                  ),
                ),
              ),
      ),
    );
  }
}
