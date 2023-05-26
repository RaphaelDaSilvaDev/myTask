import 'package:jiffy/jiffy.dart';

String dateFormatBefore2Days({dateToShow}) {
  return Jiffy.parse(dateToShow.toString())
          .isBefore(Jiffy.now().startOf(Unit.day).add(days: 2))
      ? Jiffy.parse(dateToShow.toString()).fromNow()
      : Jiffy.parse(dateToShow.toString()).MMMMEEEEd;
}

String dateFormatReturnHours({dateToShow}) {
  return Jiffy.parse(dateToShow.toString())
          .isBefore(Jiffy.now().startOf(Unit.day).add(days: 1))
      ? Jiffy.parse(dateToShow.toString()).fromNow()
      : "às ${Jiffy.parse(dateToShow.toString()).Hm}";
}

String dateFormatToTomorrow({dateToShow, addDay}) {
  return Jiffy.parse(dateToShow.toString())
          .startOf(Unit.day)
          .add(days: addDay)
          .isBefore(Jiffy.now().startOf(Unit.day).add(days: 2))
      ? "Amanhã"
      : Jiffy.parse(dateToShow.toString()).add(days: addDay).MMMMEEEEd;
}

String dateFormatToTodayAndTomorrow({dateToShow}) {
  return Jiffy.parse(dateToShow.toString())
          .startOf(Unit.day)
          .isSame(Jiffy.now().startOf(Unit.day))
      ? "Hoje"
      : Jiffy.parse(dateToShow.toString())
                  .startOf(Unit.day)
                  .isAfter(Jiffy.now().startOf(Unit.day)) &&
              Jiffy.parse(dateToShow.toString())
                  .startOf(Unit.day)
                  .isBefore(Jiffy.now().startOf(Unit.day).add(days: 2))
          ? "Amanhã"
          : Jiffy.parse(dateToShow.toString()).MMMMEEEEd;
}
