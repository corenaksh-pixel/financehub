enum FinancialYear {
  fy2025_26,
  fy2026_27,
}

extension FinancialYearExtension on FinancialYear {
  String get label {
    switch (this) {
      case FinancialYear.fy2025_26:
        return 'FY 2025-26';
      case FinancialYear.fy2026_27:
        return 'FY 2026-27';
    }
  }
}