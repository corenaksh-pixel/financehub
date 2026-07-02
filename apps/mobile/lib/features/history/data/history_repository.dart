import 'package:hive_flutter/hive_flutter.dart';

import '../domain/history_item.dart';

class HistoryRepository {
  HistoryRepository._();

  static const String _boxName = 'history';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  static Future<void> save(HistoryItem item) async {
    await _box.add(item.toJson());
  }

  static List<HistoryItem> getAll() {
    return _box.values
        .map((e) => HistoryItem.fromJson(Map<dynamic, dynamic>.from(e)))
        .toList()
        .reversed
        .toList();
  }

  static Future<void> delete(int index) async {
    await _box.deleteAt(index);
  }

  static Future<void> clear() async {
    await _box.clear();
  }
}