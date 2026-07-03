import 'package:hive_flutter/hive_flutter.dart';

class FavoritesRepository {
  static const _boxName = 'favorites';

  const FavoritesRepository._();

  static Box get _box => Hive.box(_boxName);

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  static List<String> getAll() {
    return _box.values.cast<String>().toList();
  }

  static bool isFavorite(String id) {
    return _box.containsKey(id);
  }

  static Future<void> add(String id) async {
    await _box.put(id, id);
  }

  static Future<void> remove(String id) async {
    await _box.delete(id);
  }

  static Future<void> toggle(String id) async {
    if (isFavorite(id)) {
      await remove(id);
    } else {
      await add(id);
    }
  }
}