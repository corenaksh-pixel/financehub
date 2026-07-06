class CessCalculator {
  const CessCalculator();

  double calculate({
    required double taxAfterRebate,
    required double surcharge,
    required double cessRate,
  }) {
    return (taxAfterRebate + surcharge) * cessRate;
  }
}