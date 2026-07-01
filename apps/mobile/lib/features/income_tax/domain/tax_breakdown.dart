class TaxBreakdown {
  final String slab;
  final double taxableAmount;
  final double rate;
  final double tax;

  const TaxBreakdown({
    required this.slab,
    required this.taxableAmount,
    required this.rate,
    required this.tax,
  });
}