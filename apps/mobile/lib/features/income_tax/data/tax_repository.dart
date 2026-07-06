import '../domain/financial_year.dart';
import '../domain/tax_config.dart';

import 'fy_2025_26.dart';
import 'fy_2026_27.dart';

class TaxRepository {
  const TaxRepository();

  TaxConfig getConfig(FinancialYear year) {
    switch (year) {
      case FinancialYear.fy2025_26:
        return taxConfig2025;

      case FinancialYear.fy2026_27:
        return taxConfig2026;
    }
  }
}