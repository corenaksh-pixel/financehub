import '../tax_breakdown.dart';

class SlabCalculationResult {
  final double slabTax;
  final List<TaxBreakdown> breakdown;

  const SlabCalculationResult({required this.slabTax, required this.breakdown});
}
