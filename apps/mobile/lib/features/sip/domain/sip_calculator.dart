import 'dart:math';

class SipCalculator {
  const SipCalculator._();

  static Map<String, double> calculate({
    required double monthlyInvestment,
    required double annualReturn,
    required double years,
  }) {
    if (monthlyInvestment <= 0) {
      throw ArgumentError('Monthly investment must be greater than zero.');
    }

    if (annualReturn < 0 || annualReturn > 100) {
      throw ArgumentError('Annual return must be between 0 and 100.');
    }

    if (years <= 0) {
      throw ArgumentError('Investment period must be greater than zero.');
    }

    final months = years * 12;
    final monthlyRate = annualReturn / 12 / 100;

    final maturityValue = monthlyInvestment *
        ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
        (1 + monthlyRate);

    final investedAmount = monthlyInvestment * months;
    final estimatedReturns = maturityValue - investedAmount;

    return {
      'investedAmount': investedAmount,
      'estimatedReturns': estimatedReturns,
      'maturityValue': maturityValue,
    };
  }
}