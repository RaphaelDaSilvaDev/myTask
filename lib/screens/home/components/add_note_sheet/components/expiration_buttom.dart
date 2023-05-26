// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:my_tasks/utils/date_format.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../constants/colors.dart';
import '../../../../../models/task/task_model.dart';

class ExpirationButtom extends StatefulWidget {
  const ExpirationButtom(
      {super.key, required this.task, required this.changeTime});

  final Task task;
  final dynamic changeTime;

  @override
  State<ExpirationButtom> createState() => _ExpirationButtomState(
        task: task,
        changeTime: changeTime,
      );
}

class _ExpirationButtomState extends State<ExpirationButtom> {
  final Task task;
  final dynamic changeTime;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();

  _ExpirationButtomState({required this.task, required this.changeTime});
  Future<DateTime?> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              primarySwatch: blueTheme,
              splashColor: Colors.black,
              colorScheme: const ColorScheme.light(
                primary: blue200,
              ),
              dialogBackgroundColor: gray300,
            ),
            child: child ?? const Text(""),
          );
        });
    if (selected != null) {
      setState(() {
        selectedDate = DateTime(
          selected.year,
          selected.month,
          selected.day,
        );
      });
      await onTimeChanged();
    } else {
      return null;
    }
    return selectedDate;
  }

  onTimeChanged() {
    setState(() {
      dateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
    });
    changeTime(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _selectDate(context);
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevation: MaterialStateProperty.resolveWith<double>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return 0;
            }
            return 0;
          },
        ),
        backgroundColor: MaterialStateProperty.all<Color>(gray100),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return gray900.withOpacity(0.04);
            }
            if (states.contains(MaterialState.focused) ||
                states.contains(MaterialState.pressed)) {
              return gray900.withOpacity(0.12);
            }
            return null; // Defer to the widget's default.
          },
        ),
      ),
      child: Row(
        children: [
          PhosphorIcon(
            PhosphorIcons.light.calendar,
            color: gray900,
          ),
          Text(
            dateFormatToTodayAndTomorrow(dateToShow: widget.task.expiresOn),
            style: const TextStyle(color: gray900, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
