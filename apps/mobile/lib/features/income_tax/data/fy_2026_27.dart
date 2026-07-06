import '../domain/tax_config.dart';

const taxConfig2026 = TaxConfig(
  financialYear: 'FY 2026-27',

  // Populate these values from the officially applicable rules
  // before enabling production calculations.
  standardDeduction: 0,
  rebateLimit: 0,
  maximumRebate: 0,
  cessRate: 0.04,

  slabs: [
    // Add official slab definitions here.
  ],
);