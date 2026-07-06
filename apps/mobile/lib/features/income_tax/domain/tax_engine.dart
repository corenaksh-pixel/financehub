import '../data/tax_repository.dart';
import 'calculators/cess_calculator.dart';
import 'calculators/rebate_calculator.dart';
import 'calculators/slab_calculator.dart';
import 'tax_inputs.dart';
import 'tax_result.dart';
import 'tax_validator.dart';
import 'taxpayer_type.dart';

class TaxEngine {
  TaxEngine({
    TaxRepository? repository,
    SlabCalculator? slabCalculator,
    RebateCalculator? rebateCalculator,
    CessCalculator? cessCalculator,
  })  : _repository = repository ?? const TaxRepository(),
        _slabCalculator = slabCalculator ?? const SlabCalculator(),
        _rebateCalculator =
            rebateCalculator ?? const RebateCalculator(),
        _cessCalculator =
            cessCalculator ?? const CessCalculator();

  final TaxRepository _repository;
  final SlabCalculator _slabCalculator;
  final RebateCalculator _rebateCalculator;
  final CessCalculator _cessCalculator;

  final _validator = const TaxValidator();

  TaxResult calculate(TaxInputs input) {
    _validator.validate(input);

    final config = _repository.getConfig(
      input.financialYear,
    );

    final standardDeduction =
        input.taxpayerType == TaxpayerType.salaried
            ? config.standardDeduction
            : 0.0;

    final taxableIncome =
        (input.annualIncome - standardDeduction)
            .clamp(0.0, double.infinity);

    final slabResult = _slabCalculator.calculate(
      taxableIncome: taxableIncome,
      slabs: config.slabs,
    );

    final rebate = _rebateCalculator.calculate(
      slabTax: slabResult.slabTax,
      taxableIncome: taxableIncome,
      rebateLimit: config.rebateLimit,
      maximumRebate: config.maximumRebate,
    );

    final taxAfterRebate =
        slabResult.slabTax - rebate;

    const surcharge = 0.0;

    final cess = _cessCalculator.calculate(
      taxAfterRebate: taxAfterRebate,
      surcharge: surcharge,
      cessRate: config.cessRate,
    );

    final totalTax =
        taxAfterRebate + surcharge + cess;

    return TaxResult(
      grossIncome: input.annualIncome,
      standardDeduction: standardDeduction,
      taxableIncome: taxableIncome,
      slabTax: slabResult.slabTax,
      rebate: rebate,
      surcharge: surcharge,
      cess: cess,
      totalTax: totalTax,
      monthlyTax: totalTax / 12,
      takeHome: input.annualIncome - totalTax,
      effectiveTaxRate:
          input.annualIncome == 0
              ? 0
              : (totalTax / input.annualIncome) * 100,
      breakdown: slabResult.breakdown,
      explanations: const [],
    );
  }
}