import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../domain/history_item.dart';

class HistoryRepository {
  HistoryRepository._();

  static const String _boxName = 'history';

  static final ValueNotifier<int> refresh = ValueNotifier<int>(0);

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.initFlutter();
      await Hive.openBox(_boxName);
    }
  }

  static Box get _box => Hive.box(_boxName);

  static Future<void> save(HistoryItem item) async {
    await _box.add(item.toJson());

    refresh.value = refresh.value + 1;
  }

  static List<HistoryItem> getAll() {
    return _box.values
        .map(
          (e) => HistoryItem.fromJson(
            Map<dynamic, dynamic>.from(e),
          ),
        )
        .toList()
        .reversed
        .toList();
  }

  static Future<void> deleteById(String id) async {
    final keys = _box.keys.toList();

    for (final key in keys) {
      final data = Map<dynamic, dynamic>.from(_box.get(key));

      if (data['id'] == id) {
        await _box.delete(key);
        break;
      }
    }

    refresh.value = refresh.value + 1;
  }

  static Future<void> delete(int index) async {
    final list = getAll();

    if (index < 0 || index >= list.length) return;

    await deleteById(list[index].id);
  }

  static Future<void> clear() async {
    await _box.clear();

    refresh.value = refresh.value + 1;
  }
}