import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../domain/history_item.dart';

class HistoryRepository {
  HistoryRepository._();

  static const String _boxName = 'history';

  /// Notifies listeners whenever history changes.
  static final ValueNotifier<int> refresh = ValueNotifier(0);

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.initFlutter();
      await Hive.openBox(_boxName);
    }
  }

  static Box get _box => Hive.box(_boxName);

  static Future<void> save(HistoryItem item) async {
    await _box.add(item.toJson());
    refresh.value++;
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
    refresh.value++;
  }

  static Future<void> clear() async {
    await _box.clear();
    refresh.value++;
  }
}