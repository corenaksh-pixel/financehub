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
      throw ArgumentError("Monthly deposit must be greater than zero.");
    }

    if (annualRate < 0 || annualRate > 100) {
      throw ArgumentError("Interest rate must be between 0 and 100.");
    }

    if (months <= 0) {
      throw ArgumentError("Tenure must be greater than zero.");
    }

    final periodicRate = annualRate / compoundsPerYear / 100;
    final periodsPerMonth = compoundsPerYear / 12;

    double maturity = 0;

    for (int i = 0; i < months; i++) {
      final remainingPeriods = ((months - i - 1) * periodsPerMonth).toDouble();

      maturity += monthlyDeposit * pow(1 + periodicRate, remainingPeriods);
    }
    final invested = monthlyDeposit * months;
    final interest = maturity - invested;

    return {"invested": invested, "interest": interest, "maturity": maturity};
  }
}
