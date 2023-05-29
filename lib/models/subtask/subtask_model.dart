import 'package:objectbox/objectbox.dart';

@Entity()
class SubTask {
  int id;
  String title;
  bool isDone;

  SubTask({this.id = 0, this.isDone = false, required this.title});

  bool toggleIsDone() {
    isDone = !isDone;
    return isDone;
  }
}
