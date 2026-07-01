import 'tax_breakdown.dart';

class TaxResult {
  final double grossIncome;
  final double standardDeduction;
  final double taxableIncome;
  final double incomeTax;
  final double cess;
  final double totalTax;
  final double effectiveTaxRate;

  final List<TaxBreakdown> breakdown;

  const TaxResult({
    required this.grossIncome,
    required this.standardDeduction,
    required this.taxableIncome,
    required this.incomeTax,
    required this.cess,
    required this.totalTax,
    required this.effectiveTaxRate,
    required this.breakdown,
  });
}