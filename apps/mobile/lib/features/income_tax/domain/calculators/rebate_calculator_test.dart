import 'package:flutter_test/flutter_test.dart';
import 'package:financehub/features/income_tax/domain/calculators/rebate_calculator.dart';

void main() {
  group('RebateCalculator', () {
    const calculator = RebateCalculator();

    test('returns full slab tax below rebate limit', () {
      final rebate = calculator.calculate(
        slabTax: 12000,
        taxableIncome: 700000,
        rebateLimit: 1200000,
        maximumRebate: 60000,
      );

      expect(rebate, 12000);
    });

    test('caps rebate at maximum rebate', () {
      final rebate = calculator.calculate(
        slabTax: 70000,
        taxableIncome: 700000,
        rebateLimit: 1200000,
        maximumRebate: 60000,
      );

      expect(rebate, 60000);
    });

    test('returns zero above rebate limit', () {
      final rebate = calculator.calculate(
        slabTax: 20000,
        taxableIncome: 1300000,
        rebateLimit: 1200000,
        maximumRebate: 60000,
      );

      expect(rebate, 0);
    });
  });
}