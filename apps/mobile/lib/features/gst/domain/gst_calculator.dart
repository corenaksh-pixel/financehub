class GstCalculator {
  const GstCalculator._();

  static Map<String, double> calculate({
    required double amount,
    required double gstRate,
    required bool isAddGst,
  }) {
    if (amount <= 0) {
      throw ArgumentError('Amount must be greater than zero.');
    }

    if (gstRate < 0 || gstRate > 100) {
      throw ArgumentError('GST rate must be between 0 and 100.');
    }

    double gstAmount;
    double finalAmount;
    double baseAmount;

    if (isAddGst) {
      gstAmount = amount * gstRate / 100;
      finalAmount = amount + gstAmount;
      baseAmount = amount;
    } else {
      baseAmount = amount / (1 + gstRate / 100);
      gstAmount = amount - baseAmount;
      finalAmount = amount;
    }

    return {
      'baseAmount': baseAmount,
      'gstAmount': gstAmount,
      'finalAmount': finalAmount,
    };
  }
}