class CalculationMetadata {

  final String appVersion;

  final String engineVersion;

  final String calculatorVersion;

  final DateTime generatedAt;

  const CalculationMetadata({
    required this.appVersion,
    required this.engineVersion,
    required this.calculatorVersion,
    required this.generatedAt,
  });

}