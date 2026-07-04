import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesRepository {
  static const _boxName = 'favorites';

  static final ValueNotifier<int> refresh = ValueNotifier(0);

  const FavoritesRepository._();

  static Box get _box => Hive.box(_boxName);

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  static List<String> getAll() {
    return _box.keys.cast<String>().toList();
  }

  static bool isFavorite(String id) {
    return _box.containsKey(id);
  }

  static Future<void> add(String id) async {
    await _box.put(id, true);
    refresh.value++;
  }

  static Future<void> remove(String id) async {
    await _box.delete(id);
    refresh.value++;
  }

  static Future<void> toggle(String id) async {
    if (isFavorite(id)) {
      await remove(id);
    } else {
      await add(id);
    }
  }
}