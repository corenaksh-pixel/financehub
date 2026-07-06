import 'tax_slab.dart';

class TaxConfig {
  final String financialYear;
  final double standardDeduction;
  final double rebateLimit;
  final double maximumRebate;
  final double cessRate;
  final List<TaxSlab> slabs;

  const TaxConfig({
    required this.financialYear,
    required this.standardDeduction,
    required this.rebateLimit,
    required this.maximumRebate,
    required this.cessRate,
    required this.slabs,
  });
}