class SipResult {
  final double investedAmount;
  final double estimatedReturns;
  final double maturityValue;
  final double monthlyInvestment;
  final double annualRate;
  final int years;

  const SipResult({
    required this.investedAmount,
    required this.estimatedReturns,
    required this.maturityValue,
    required this.monthlyInvestment,
    required this.annualRate,
    required this.years,
  });
}