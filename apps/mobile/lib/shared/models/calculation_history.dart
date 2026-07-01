class CalculationHistory {
  final String id;
  final String calculator;
  final String title;
  final String result;
  final DateTime createdAt;

  const CalculationHistory({
    required this.id,
    required this.calculator,
    required this.title,
    required this.result,
    required this.createdAt,
  });
}