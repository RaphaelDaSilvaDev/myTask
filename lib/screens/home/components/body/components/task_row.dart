// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:my_tasks/models/task/task_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../constants/colors.dart';
import '../../open_bottom_sheet.dart';

class taskRowWidget extends StatefulWidget {
  final Task task;
  final Function updatedChecked;

  const taskRowWidget(
      {super.key, required this.task, required this.updatedChecked});

  @override
  State<taskRowWidget> createState() => _taskRowWidgetState();
}

class _taskRowWidgetState extends State<taskRowWidget> {
  var isChecked = false;
  var isOpen = false;
  var turns = 0.0;

  @override
  Widget build(BuildContext context) {
    var isBeforeToday = Jiffy.parse(widget.task.finishedAt != null
            ? widget.task.finishedAt!.toString()
            : DateTime.now().toString())
        .isBefore(Jiffy.now()
            .startOf(Unit.day)
            .add(hours: 23, minutes: 59, seconds: 59));

    var isAfterToday = widget.task.finishedAt != null &&
        Jiffy.parse(widget.task.finishedAt.toString()).isBefore(Jiffy.now());

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
                    updatedChecked: widget.updatedChecked);
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
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 1.4,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      color: gray300,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Checkbox(
                                    checkColor: gray100,
                                    fillColor: widget
                                            .task.subtasks[index].isDone
                                        ? MaterialStateProperty.all(blue200)
                                        : MaterialStateProperty.all(gray300),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    value: widget.task.subtasks[index].isDone,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        widget.task.subtasks[index].isDone =
                                            value!;
                                        widget.updatedChecked(widget.task);
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(widget.task.subtasks[index].title)
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  widget.task.finishedAt != null
                      ? isBeforeToday
                          ? Jiffy.parse(widget.task.finishedAt.toString())
                              .fromNow()
                          : Jiffy.parse(widget.task.finishedAt.toString())
                              .MMMMEEEEd
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
                    value: widget.task.isDone,
                    onChanged: (bool? value) {
                      widget.task.isDone = value!;
                      if (value == true) {
                        widget.task.doAt = DateTime.now();
                      } else {
                        widget.task.doAt = null;
                      }
                      widget.updatedChecked(widget.task);
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
