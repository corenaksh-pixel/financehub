import 'tax_engine.dart';
import 'tax_inputs.dart';
import 'tax_result.dart';

class IncomeTaxCalculator {
  static final _engine = TaxEngine();

  static TaxResult calculate({
    required TaxInputs input,
  }) {
    return _engine.calculate(input);
  }
}