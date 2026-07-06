import '../domain/tax_config.dart';
import '../domain/tax_slab.dart';

const taxConfig2026 = TaxConfig(
  financialYear: 'FY 2026-27',

  // Salaried new regime
  standardDeduction: 75000,

  // Section 87A
  rebateLimit: 1200000,
  maximumRebate: 60000,

  // Health & Education Cess
  cessRate: 0.04,

  slabs: [
    TaxSlab(from: 0,        to: 400000,   rate: 0.00),
    TaxSlab(from: 400000,   to: 800000,   rate: 0.05),
    TaxSlab(from: 800000,   to: 1200000,  rate: 0.10),
    TaxSlab(from: 1200000,  to: 1600000,  rate: 0.15),
    TaxSlab(from: 1600000,  to: 2000000,  rate: 0.20),
    TaxSlab(from: 2000000,  to: 2400000,  rate: 0.25),
    TaxSlab(from: 2400000,  to: double.infinity, rate: 0.30),
  ],
);