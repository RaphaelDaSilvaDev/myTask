import 'package:objectbox/objectbox.dart';

@Entity()
class Workspace {
  int id;
  String name;
  bool? isDefault;
  DateTime? createdAt;

  Workspace({
    this.id = 0,
    required this.name,
    this.isDefault = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
