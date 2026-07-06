import 'tax_result.dart';

class IncomeTaxCalculator {
  static TaxResult calculate({
    required double annualIncome,
  }) {
    return TaxResult(
      grossIncome: annualIncome,
      standardDeduction: 0,
      taxableIncome: annualIncome,
      slabTax: 0,
      rebate: 0,
      surcharge: 0,
      cess: 0,
      totalTax: 0,
      monthlyTax: 0,
      takeHome: annualIncome,
      effectiveTaxRate: 0,
      breakdown: const [],
      explanations: const [],
    );
  }
}