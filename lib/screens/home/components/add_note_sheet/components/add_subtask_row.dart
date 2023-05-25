// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_tasks/models/subtask/subtask_model.dart';

import '../../../../../constants/colors.dart';

class AddSubtaskRow extends StatefulWidget {
  final Function? addSubtask;
  const AddSubtaskRow({super.key, this.addSubtask});

  @override
  State<AddSubtaskRow> createState() => _AddSubtaskRowState();
}

class _AddSubtaskRowState extends State<AddSubtaskRow> {
  TextEditingController myTitle = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  @override
  void dispose() {
    myTitle.dispose();
    super.dispose();
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
                fillColor: MaterialStateProperty.all(gray300),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                value: false,
                onChanged: (value) {},
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
              focusNode: myFocusNode,
              style: const TextStyle(fontSize: 14, color: gray900),
              decoration: const InputDecoration(
                isCollapsed: true,
                hintText: "Subtarefa...",
                border: InputBorder.none,
              ),
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  widget.addSubtask!(SubTask(title: myTitle.text));
                  setState(() {
                    myTitle.clear();
                    myFocusNode.requestFocus();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
