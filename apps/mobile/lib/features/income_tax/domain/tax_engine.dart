import '../data/tax_repository.dart';
import 'tax_inputs.dart';
import 'tax_result.dart';
import 'tax_validator.dart';
import 'taxpayer_type.dart';

class TaxEngine {
  TaxEngine({
    TaxRepository? repository,
  }) : _repository = repository ?? const TaxRepository();

  final TaxRepository _repository;

  final _validator = const TaxValidator();

  TaxResult calculate(TaxInputs input) {
    _validator.validate(input);

    final config = _repository.getConfig(
      input.financialYear,
    );

    // Standard deduction
    final standardDeduction =
        input.taxpayerType == TaxpayerType.salaried
            ? config.standardDeduction
            : 0.0;

    // Taxable income
    final taxableIncome =
        (input.annualIncome - standardDeduction)
            .clamp(0.0, double.infinity);

    // TODO:
    // Slab Tax
    // Rebate
    // Surcharge
    // Marginal Relief
    // Cess

    return TaxResult(
      grossIncome: input.annualIncome,
      standardDeduction: standardDeduction,
      taxableIncome: taxableIncome,
      slabTax: 0,
      rebate: 0,
      surcharge: 0,
      cess: 0,
      totalTax: 0,
      monthlyTax: 0,
      takeHome: input.annualIncome,
      effectiveTaxRate: 0,
      breakdown: const [],
      explanations: const [],
    );
  }
}