class EmiSchedule {
  final int month;
  final double emi;
  final double principal;
  final double interest;
  final double balance;

  const EmiSchedule({
    required this.month,
    required this.emi,
    required this.principal,
    required this.interest,
    required this.balance,
  });
}