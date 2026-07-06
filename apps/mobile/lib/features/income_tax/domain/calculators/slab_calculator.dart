import '../tax_breakdown.dart';
import '../tax_slab.dart';
import 'slab_calculation_result.dart';

class SlabCalculator {
  const SlabCalculator();

  SlabCalculationResult calculate({
    required double taxableIncome,
    required List<TaxSlab> slabs,
  }) {
    double totalTax = 0;
    final breakdown = <TaxBreakdown>[];

    for (final slab in slabs) {
      if (taxableIncome <= slab.from) {
        break;
      }

      final upperLimit =
          slab.to == double.infinity ? taxableIncome : slab.to;

      final taxableAmount =
          (taxableIncome < upperLimit ? taxableIncome : upperLimit) -
          slab.from;

      if (taxableAmount <= 0) continue;

      final tax = taxableAmount * slab.rate;

      totalTax += tax;

      breakdown.add(
        TaxBreakdown(
          slab: slab.to == double.infinity
              ? 'Above ₹${slab.from.toStringAsFixed(0)}'
              : '₹${slab.from.toStringAsFixed(0)} - ₹${slab.to.toStringAsFixed(0)}',
          rate: slab.rate,
          taxableAmount: taxableAmount,
          tax: tax,
        ),
      );
    }

    return SlabCalculationResult(
      slabTax: totalTax,
      breakdown: breakdown,
    );
  }
}