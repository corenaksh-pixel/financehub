import 'tax_engine.dart';
import 'tax_regime.dart';
import 'tax_result.dart';

class IncomeTaxCalculator {
  const IncomeTaxCalculator._();

  static TaxResult calculate({
    required double annualIncome,
  }) {
    return TaxEngine.calculate(
      grossIncome: annualIncome,
      regime: TaxRegime.newRegime,
    );
  }
}