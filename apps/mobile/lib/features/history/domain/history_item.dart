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
      id: json['id'] as String,
      calculator: json['calculator'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      inputs: Map<String, dynamic>.from(json['inputs'] as Map),
      results: Map<String, dynamic>.from(json['results'] as Map),
    );
  }
}