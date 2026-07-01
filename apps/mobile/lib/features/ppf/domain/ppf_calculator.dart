class PpfCalculator {
  const PpfCalculator._();

  static Map<String, double> calculate({
    required double yearlyInvestment,
    required double annualRate,
    required int years,
  }) {
    if (yearlyInvestment <= 0) {
      throw ArgumentError(
        'Yearly investment must be greater than zero.',
      );
    }

    if (annualRate < 0 || annualRate > 100) {
      throw ArgumentError(
        'Interest rate must be between 0 and 100.',
      );
    }

    if (years <= 0) {
      throw ArgumentError(
        'Years must be greater than zero.',
      );
    }

    double balance = 0;

    for (int i = 0; i < years; i++) {
      balance += yearlyInvestment;
      balance *= (1 + annualRate / 100);
    }

    final invested = yearlyInvestment * years;
    final interest = balance - invested;

    return {
      'invested': invested,
      'interest': interest,
      'maturity': balance,
    };
  }
}