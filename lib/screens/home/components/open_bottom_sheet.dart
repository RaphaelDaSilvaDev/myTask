import 'package:flutter/material.dart';
import '../../../models/task/task_model.dart';
import 'add_note_sheet/add_note_sheet.dart';

openBottomSheet(
    {required BuildContext context, Task? task, Function? updatedChecked}) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      useSafeArea: false,
      isScrollControlled: true,
      builder: (_) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: AddNoteSheet(
              task: task,
            ),
          ));
}
