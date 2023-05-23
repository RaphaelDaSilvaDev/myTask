// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_tasks/models/subtask/subtask_model.dart';

import '../../../../../constants/colors.dart';

class SubtaskRow extends StatefulWidget {
  SubTask? subtask;
  final Function? addSubtask;
  SubtaskRow({super.key, this.subtask, this.addSubtask});

  @override
  State<SubtaskRow> createState() => _SubtaskRowState();
}

class _SubtaskRowState extends State<SubtaskRow> {
  TextEditingController title = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.subtask != null) title.text = widget.subtask!.title;
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
                fillColor:
                    widget.subtask?.isDone != null && widget.subtask!.isDone
                        ? MaterialStateProperty.all(blue200)
                        : MaterialStateProperty.all(gray300),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                value: widget.subtask?.isDone ?? false,
                onChanged: (bool? value) {
                  widget.subtask?.isDone = value!;
                },
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 150,
            child: RawKeyboardListener(
              focusNode: FocusNode(onKey: (node, event) {
                if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  return KeyEventResult
                      .handled; // prevent passing the event into the TextField
                }
                return KeyEventResult
                    .ignored; // pass the event to the TextField
              }),
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.enter) &&
                    title.text.isNotEmpty) {
                  if (widget.subtask == null) {
                    widget.addSubtask!(SubTask(title: title.text));
                  } else {
                    widget.addSubtask!(widget.subtask);
                  }
                  setState(() {
                    title.clear();
                  });
                }
              },
              child: TextFormField(
                maxLines: 1,
                minLines: 1,
                controller: title,
                style: TextStyle(
                    fontSize: 14,
                    color:
                        widget.subtask?.isDone != null && widget.subtask!.isDone
                            ? gray500
                            : gray900),
                decoration: const InputDecoration(
                  isCollapsed: true,
                  hintText: "Subtarefa...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
