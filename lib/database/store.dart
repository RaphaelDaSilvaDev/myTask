import 'objectbox.g.dart';

class CreateStore {
  static Future<Store> create() async {
    final store = await openStore();
    return store;
  }
}
