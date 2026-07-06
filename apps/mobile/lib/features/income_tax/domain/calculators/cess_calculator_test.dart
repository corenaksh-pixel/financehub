import 'package:financehub/features/income_tax/domain/calculators/cess_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CessCalculator', () {
    const calculator = CessCalculator();

    test('calculates 4% cess', () {
      final cess = calculator.calculate(
        taxAfterRebate: 100000,
        surcharge: 10000,
        cessRate: 0.04,
      );

      expect(cess, 4400);
    });

    test('returns zero for zero tax', () {
      final cess = calculator.calculate(
        taxAfterRebate: 0,
        surcharge: 0,
        cessRate: 0.04,
      );

      expect(cess, 0);
    });
  });
}