import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financehub/core/services/history_service.dart';
import 'package:financehub/features/history/domain/history_item.dart';

final historyProvider = NotifierProvider<HistoryNotifier, List<HistoryItem>>(
  HistoryNotifier.new,
);

class HistoryNotifier extends Notifier<List<HistoryItem>> {
  @override
  List<HistoryItem> build() {
    return HistoryService.getAll();
  }

  void refresh() {
    state = HistoryService.getAll();
  }

  Future<void> clear() async {
    await HistoryService.clear();
    refresh();
  }

  Future<void> deleteById(String id) async {
    // Remove immediately from UI
    state = state.where((item) => item.id != id).toList();

    // Delete from Hive
    await HistoryService.deleteById(id);
  }
}
