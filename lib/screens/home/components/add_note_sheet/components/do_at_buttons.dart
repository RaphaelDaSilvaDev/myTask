// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously

import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../constants/colors.dart';
import '../../../../../models/task/task_model.dart';

class DoAtButton extends StatefulWidget {
  const DoAtButton({super.key, required this.task, required this.changeTime});

  final Task task;
  final dynamic changeTime;

  @override
  State<DoAtButton> createState() => _DoAtButtonState(
        task: task,
        changeTime: changeTime,
      );
}

class _DoAtButtonState extends State<DoAtButton> {
  final Task task;
  final dynamic changeTime;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();

  _DoAtButtonState({required this.task, required this.changeTime});
  Future<DateTime?> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
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
            widget.task.doAt?.hour ?? selectedTime.hour,
            widget.task.doAt?.minute ?? selectedTime.minute);
      });
      await _selectTime(context);
    } else {
      return null;
    }
    return selectedDate;
  }

  Future _selectTime(BuildContext context) async {
    Navigator.of(context).push(showPicker(
        accentColor: blue200,
        iosStylePicker: true,
        cancelText: "Cancelar",
        minuteLabel: "minutos",
        hourLabel: "horas",
        is24HrFormat: true,
        height: 350,
        cancelStyle: const TextStyle(color: blue200),
        okStyle: const TextStyle(color: blue200),
        context: context,
        value: Time(hour: selectedDate.hour, minute: selectedDate.minute),
        onChange: onTimeChanged));
  }

  void onTimeChanged(Time newTime) {
    setState(() {
      dateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        newTime.hour,
        newTime.minute,
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
            // Change your radius here
            borderRadius: BorderRadius.circular(8),
          ),
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
            widget.task.finishedAt != null
                ? Jiffy.parse(task.finishedAt != null
                            ? task.finishedAt!.toString()
                            : DateTime.now().toString())
                        .isBefore(Jiffy.now()
                            .startOf(Unit.day)
                            .add(hours: 23, minutes: 59, seconds: 59))
                    ? Jiffy.parse(widget.task.finishedAt.toString()).fromNow()
                    : Jiffy.parse(widget.task.finishedAt.toString()).MMMMEEEEd
                : "Expiração",
            style: const TextStyle(color: gray900, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
