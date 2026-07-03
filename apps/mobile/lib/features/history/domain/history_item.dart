class HistoryItem {
  final String id;
  final String calculator;
  final DateTime createdAt;

  final Map<String, dynamic> inputs;
  final Map<String, dynamic> results;

  const HistoryItem({
    required this.id,
    required this.calculator,
    required this.createdAt,
    required this.inputs,
    required this.results,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'calculator': calculator,
      'createdAt': createdAt.toIso8601String(),
      'inputs': inputs,
      'results': results,
    };
  }

  factory HistoryItem.fromJson(Map<dynamic, dynamic> json) {
    return HistoryItem(
      id: (json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString())
          .toString(),
      calculator: (json['calculator'] ?? 'Unknown').toString(),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      inputs: Map<String, dynamic>.from(json['inputs'] ?? {}),
      results: Map<String, dynamic>.from(json['results'] ?? {}),
    );
  }
}
