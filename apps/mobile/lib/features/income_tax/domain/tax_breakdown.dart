class TaxBreakdown {
  final String slab;
  final double rate;
  final double taxableAmount;
  final double tax;

  const TaxBreakdown({
    required this.slab,
    required this.rate,
    required this.taxableAmount,
    required this.tax,
  });
}