import 'package:flutter/material.dart';
import 'package:my_tasks/main.dart';
import 'package:my_tasks/models/subtask/subtask_model.dart';

import '../constants/colors.dart';

class SubTaskRow extends StatefulWidget {
  const SubTaskRow(
      {super.key, required this.subtask, required this.verifyAllSubtaskIsDone});

  final Function verifyAllSubtaskIsDone;
  final SubTask subtask;

  @override
  State<SubTaskRow> createState() => _SubTaskRowState();
}

class _SubTaskRowState extends State<SubTaskRow> {
  late bool isChecked;

  void toggleIsDone() {
    bool newStatus = widget.subtask.toggleIsDone();

    subtaskRepository.subtaskBox.put(widget.subtask);
    widget.verifyAllSubtaskIsDone();

    setState(() {
      isChecked = newStatus;
    });
  }

  @override
  void initState() {
    isChecked = widget.subtask.isDone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  color: gray300, borderRadius: BorderRadius.circular(6)),
              child: Checkbox(
                checkColor: gray100,
                fillColor: isChecked
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
          ),
          const SizedBox(
            width: 10,
          ),
          Text(widget.subtask.title)
        ],
      ),
    );
  }
}
