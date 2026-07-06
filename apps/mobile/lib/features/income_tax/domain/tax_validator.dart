import 'tax_inputs.dart';

class TaxValidator {
  const TaxValidator();

  void validate(TaxInputs input) {
    if (input.annualIncome < 0) {
      throw ArgumentError(
        'Annual income cannot be negative.',
      );
    }
  }
}