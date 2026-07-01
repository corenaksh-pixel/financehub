import 'tax_breakdown.dart';
import 'tax_regime.dart';
import 'tax_result.dart';

class TaxEngine {
  const TaxEngine._();

  static TaxResult calculate({
    required double grossIncome,
    required TaxRegime regime,
  }) {
    if (grossIncome <= 0) {
      throw ArgumentError('Gross income must be greater than zero.');
    }

    final taxableIncome =
        (grossIncome - regime.standardDeduction)
            .clamp(0.0, double.infinity)
            .toDouble();

    final List<TaxBreakdown> breakdown = [];

    double incomeTax = 0.0;

    for (final slab in regime.slabs) {
      if (taxableIncome <= slab.from) break;

      final upper =
          taxableIncome > slab.to ? slab.to : taxableIncome;

      final taxableAmount = (upper - slab.from).toDouble();

      final slabTax =
          taxableAmount * slab.rate / 100.0;

      incomeTax += slabTax;

      breakdown.add(
        TaxBreakdown(
          slab:
              "₹${slab.from.toInt()} - ${slab.to == double.infinity ? "Above" : "₹${slab.to.toInt()}"}",
          taxableAmount: taxableAmount,
          rate: slab.rate,
          tax: slabTax,
        ),
      );
    }

    // Temporary rebate
    if (taxableIncome <= 1200000) {
      incomeTax = 0;
    }

    final cess = incomeTax * 0.04;

    final totalTax = incomeTax + cess;

    final effectiveRate =
        grossIncome == 0
            ? 0
            : totalTax / grossIncome * 100;

    return TaxResult(
      grossIncome: grossIncome,
      standardDeduction: regime.standardDeduction,
      taxableIncome: taxableIncome,
      incomeTax: incomeTax,
      cess: cess,
      totalTax: totalTax,
      effectiveTaxRate: effectiveRate.toDouble(),
      breakdown: breakdown,
    );
  }
}