import 'financial_year.dart';
import 'taxpayer_type.dart';

class TaxInputs {
  final double annualIncome;
  final FinancialYear financialYear;
  final TaxpayerType taxpayerType;

  const TaxInputs({
    required this.annualIncome,
    required this.financialYear,
    required this.taxpayerType,
  });
}