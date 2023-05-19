class Task {
  String? id;
  String title;
  bool isDone;
  bool isArchived;
  DateTime createdAt;

  Task(
      {this.id,
      required this.title,
      this.isDone = false,
      this.isArchived = false,
      required this.createdAt});
}
