class RebateCalculator {
  const RebateCalculator();

  double calculate({
    required double slabTax,
    required double taxableIncome,
    required double rebateLimit,
    required double maximumRebate,
  }) {
    if (taxableIncome <= rebateLimit) {
      return slabTax > maximumRebate
          ? maximumRebate
          : slabTax;
    }

    return 0;
  }
}