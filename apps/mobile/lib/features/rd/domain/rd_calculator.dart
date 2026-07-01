import 'dart:math';

class RdCalculator {
  const RdCalculator._();

  static Map<String, double> calculate({
    required double monthlyDeposit,
    required double annualRate,
    required int months,
    required int compoundsPerYear,
  }) {
    if (monthlyDeposit <= 0) {
      throw ArgumentError(
        'Monthly deposit must be greater than zero.',
      );
    }

    if (annualRate < 0 || annualRate > 100) {
      throw ArgumentError(
        'Interest rate must be between 0 and 100.',
      );
    }

    if (months <= 0) {
      throw ArgumentError(
        'Tenure must be greater than zero.',
      );
    }

    if (compoundsPerYear <= 0) {
      throw ArgumentError(
        'Invalid compounding frequency.',
      );
    }

    final monthlyRate = annualRate / 12 / 100;

    double maturity = 0;

    for (int i = 0; i < months; i++) {
      maturity +=
          monthlyDeposit *
          pow(1 + monthlyRate, months - i);
    }

    final invested = monthlyDeposit * months;
    final interest = maturity - invested;

    return {
      "invested": invested,
      "interest": interest,
      "maturity": maturity,
    };
  }
}