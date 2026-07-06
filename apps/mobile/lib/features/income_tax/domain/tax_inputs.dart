import 'financial_year.dart';
import 'taxpayer_type.dart';

class TaxInputs {
  final FinancialYear financialYear;
  final TaxpayerType taxpayerType;

  /// Gross annual income before any deductions.
  final double annualIncome;

  const TaxInputs({
    required this.financialYear,
    required this.taxpayerType,
    required this.annualIncome,
  });
}