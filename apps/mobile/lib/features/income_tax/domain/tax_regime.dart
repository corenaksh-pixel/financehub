import 'tax_slab.dart';

class TaxRegime {
  final String name;
  final double standardDeduction;
  final List<TaxSlab> slabs;

  const TaxRegime({
    required this.name,
    required this.standardDeduction,
    required this.slabs,
  });

  static const newRegime = TaxRegime(
    name: 'New Regime FY 2026-27',
    standardDeduction: 75000,
    slabs: [
      TaxSlab(from: 0, to: 400000, rate: 0),
      TaxSlab(from: 400000, to: 800000, rate: 5),
      TaxSlab(from: 800000, to: 1200000, rate: 10),
      TaxSlab(from: 1200000, to: 1600000, rate: 15),
      TaxSlab(from: 1600000, to: 2000000, rate: 20),
      TaxSlab(from: 2000000, to: 2400000, rate: 25),
      TaxSlab(from: 2400000, to: double.infinity, rate: 30),
    ],
  );
}