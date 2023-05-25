// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_tasks/models/subtask/subtask_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../constants/colors.dart';

class SubtaskRow extends StatefulWidget {
  SubTask subtask;
  final Function updateSubtask;
  final Function removeSubtask;
  SubtaskRow({
    super.key,
    required this.subtask,
    required this.updateSubtask,
    required this.removeSubtask,
  });

  @override
  State<SubtaskRow> createState() => _SubtaskRowState();
}

class _SubtaskRowState extends State<SubtaskRow> {
  TextEditingController myTitle = TextEditingController();

  @override
  void dispose() {
    myTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myTitle.text = widget.subtask.title;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Row(
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
                    fillColor: widget.subtask.isDone
                        ? MaterialStateProperty.all(blue200)
                        : MaterialStateProperty.all(gray300),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    value: widget.subtask.isDone,
                    onChanged: (bool? value) {
                      widget.subtask.isDone = value!;
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 150,
                child: TextFormField(
                  maxLines: 1,
                  minLines: 1,
                  controller: myTitle,
                  style: TextStyle(
                      fontSize: 14,
                      color: widget.subtask.isDone ? gray500 : gray900),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    hintText: "Subtarefa...",
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      widget.subtask.title = myTitle.text;
                      widget.updateSubtask(widget.subtask);
                    }
                  },
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              widget.removeSubtask(widget.subtask);
              setState(() => {});
            },
            child: PhosphorIcon(
              PhosphorIcons.light.x,
              color: red300,
              size: 24,
            ),
          )
        ],
      ),
    );
  }
}
