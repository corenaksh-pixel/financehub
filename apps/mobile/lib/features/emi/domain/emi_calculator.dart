import 'dart:math';

class EmiCalculator {
  static Map<String, double> calculate({
    required double principal,
    required double annualRate,
    required double years,
  }) {
    final monthlyRate = annualRate / 12 / 100;
    final months = years * 12;

    final monthlyEmi = principal *
        monthlyRate *
        pow(1 + monthlyRate, months) /
        (pow(1 + monthlyRate, months) - 1);

    final totalPayment = monthlyEmi * months;
    final totalInterest = totalPayment - principal;

    return {
      'emi': monthlyEmi,
      'interest': totalInterest,
      'payment': totalPayment,
    };
  }
}