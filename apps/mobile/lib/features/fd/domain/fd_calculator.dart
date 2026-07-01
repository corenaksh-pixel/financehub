import 'dart:math';

class FdCalculator {
  const FdCalculator._();

  static Map<String, double> calculate({
    required double principal,
    required double annualRate,
    required double years,
    required int compoundsPerYear,
  }) {
    if (principal <= 0) {
      throw ArgumentError('Principal amount must be greater than zero.');
    }

    if (annualRate < 0 || annualRate > 100) {
      throw ArgumentError('Annual interest rate must be between 0 and 100.');
    }

    if (years <= 0) {
      throw ArgumentError('Tenure must be greater than zero.');
    }

    if (compoundsPerYear <= 0) {
      throw ArgumentError('Compounding frequency is invalid.');
    }

    final rate = annualRate / 100;

    final maturityAmount =
        principal * pow(1 + (rate / compoundsPerYear), compoundsPerYear * years);

    final interestEarned = maturityAmount - principal;

    return {
      'principal': principal,
      'interest': interestEarned,
      'maturity': maturityAmount,
    };
  }
}
