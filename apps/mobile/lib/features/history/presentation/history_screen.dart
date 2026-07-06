import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financehub/core/services/history_service.dart';
import 'package:financehub/features/history/domain/history_item.dart';

final historyProvider =
    NotifierProvider<HistoryNotifier, List<HistoryItem>>(
      HistoryNotifier.new,
    );

class HistoryNotifier extends Notifier<List<HistoryItem>> {
  @override
  List<HistoryItem> build() {
    return HistoryService.getAll();
  }

  Future<void> save({
    required String calculator,
    required Map<String, dynamic> inputs,
    required Map<String, dynamic> results,
  }) async {
    await HistoryService.save(
      calculator: calculator,
      inputs: inputs,
      results: results,
    );

    state = HistoryService.getAll();
  }

  Future<void> delete(int index) async {
    await HistoryService.delete(index);
    state = HistoryService.getAll();
  }

  Future<void> clear() async {
    await HistoryService.clear();
    state = HistoryService.getAll();
  }

  void refresh() {
    state = HistoryService.getAll();
  }
}