import 'package:my_tasks/database/objectbox.g.dart';

class ObjectBoxDatabase {
  Store? _store;

  Future<Store> getStore() async {
    return _store ??= await openStore();
  }
}
