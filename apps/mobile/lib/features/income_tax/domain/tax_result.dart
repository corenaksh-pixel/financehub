import 'tax_breakdown.dart';

class TaxResult {
  final double grossIncome;
  final double standardDeduction;
  final double taxableIncome;

  final double slabTax;

  final double rebate;

  final double surcharge;

  final double cess;

  final double totalTax;

  final double monthlyTax;

  final double takeHome;

  final double effectiveTaxRate;

  final List<TaxBreakdown> breakdown;

  final List<String> explanations;

    const TaxResult({
    required this.grossIncome,
    required this.standardDeduction,
    required this.taxableIncome,
    required this.slabTax,
    required this.rebate,
    required this.surcharge,
    required this.cess,
    required this.totalTax,
    required this.monthlyTax,
    required this.takeHome,
    required this.effectiveTaxRate,
    required this.breakdown,
    required this.explanations,
  });

  // Temporary compatibility getter for the current UI.
  // We'll remove this after the UI is migrated to use totalTax/slabTax directly.
  double get incomeTax => slabTax;
}