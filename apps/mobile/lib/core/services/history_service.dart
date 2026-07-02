import 'package:financehub/features/history/data/history_repository.dart';
import 'package:financehub/features/history/domain/history_item.dart';

class HistoryService {
  const HistoryService._();

  static Future<void> save({
    required String calculator,
    required Map<String, dynamic> inputs,
    required Map<String, dynamic> results,
  }) async {
    await HistoryRepository.save(
      HistoryItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        calculator: calculator,
        createdAt: DateTime.now(),
        inputs: inputs,
        results: results,
      ),
    );
  }

  static List<HistoryItem> getAll() {
    return HistoryRepository.getAll();
  }

  static Future<void> delete(int index) {
    return HistoryRepository.delete(index);
  }

  static Future<void> clear() {
    return HistoryRepository.clear();
  }
}