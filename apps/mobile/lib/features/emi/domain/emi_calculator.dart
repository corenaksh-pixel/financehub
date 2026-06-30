import 'dart:math';

import 'package:financehub/features/emi/domain/emi_schedule.dart';

class EmiCalculator {
  /// Calculates EMI summary
  static Map<String, double> calculate({
    required double principal,
    required double annualRate,
    required double years,
  }) {
    final monthlyRate = annualRate / 12 / 100;
    final months = (years * 12).round();

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

  /// Generates complete amortization schedule
  static List<EmiSchedule> generateSchedule({
    required double principal,
    required double annualRate,
    required double years,
  }) {
    final monthlyRate = annualRate / 12 / 100;
    final months = (years * 12).round();

    final monthlyEmi = calculate(
      principal: principal,
      annualRate: annualRate,
      years: years,
    )['emi']!;

    double balance = principal;

    final List<EmiSchedule> schedule = [];

    for (int month = 1; month <= months; month++) {
      final interest = balance * monthlyRate;
      final principalPaid = monthlyEmi - interest;

      balance -= principalPaid;

      if (balance < 0) {
        balance = 0;
      }

      schedule.add(
        EmiSchedule(
          month: month,
          emi: monthlyEmi,
          principal: principalPaid,
          interest: interest,
          balance: balance,
        ),
      );
    }

    return schedule;
  }
}