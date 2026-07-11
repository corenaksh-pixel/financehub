import 'package:financehub/core/services/share_service.dart';
import 'package:financehub/features/income_tax/domain/income_tax_calculator.dart';
import 'package:financehub/features/income_tax/domain/tax_result.dart';
import 'package:financehub/features/income_tax/presentation/widgets/tax_breakdown_table.dart';
import 'package:financehub/shared/widgets/app_number_field.dart';
import 'package:financehub/shared/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:financehub/core/services/history_service.dart';
import '../domain/tax_inputs.dart';
import '../domain/financial_year.dart';
import '../domain/taxpayer_type.dart';
import 'package:financehub/core/pdf/pdf_export_service.dart';
import 'package:financehub/features/income_tax/pdf/income_tax_pdf.dart';
import 'package:financehub/shared/widgets/summary_card.dart';

class IncomeTaxScreen extends StatefulWidget {
  const IncomeTaxScreen({super.key});

  @override
  State<IncomeTaxScreen> createState() => _IncomeTaxScreenState();
}

class _IncomeTaxScreenState extends State<IncomeTaxScreen> {
  final _incomeController = TextEditingController();

  FinancialYear _financialYear = FinancialYear.fy2026_27;
  TaxpayerType _taxpayerType = TaxpayerType.salaried;

  final formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 2,
  );

  TaxResult? result;

  Future<void> calculate() async {
    FocusScope.of(context).unfocus();

    final income = double.tryParse(_incomeController.text.trim());

    if (income == null || income <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid annual income.')),
      );
      return;
    }

    setState(() {
      result = IncomeTaxCalculator.calculate(
        input: TaxInputs(
          annualIncome: income,
          financialYear: _financialYear,
          taxpayerType: _taxpayerType,
        ),
      );
    });

    await HistoryService.save(
      calculator: 'Income Tax',
      inputs: {
        'Annual Income': income,
        'Financial Year': _financialYear == FinancialYear.fy2025_26
            ? 'FY 2025-26'
            : 'FY 2026-27',
        'Taxpayer Type': _taxpayerType == TaxpayerType.salaried
            ? 'Salaried'
            : 'Non-Salaried',
      },
      results: {
        'Gross Income': result!.grossIncome,
        'Standard Deduction': result!.standardDeduction,
        'Taxable Income': result!.taxableIncome,
        'Income Tax': result!.totalTax,
        'Health & Education Cess': result!.cess,
        'Total Tax': result!.totalTax,
        'Effective Tax Rate': '${result!.effectiveTaxRate.toStringAsFixed(2)}%',
      },
    );
  }

  void reset() {
    _incomeController.clear();

    setState(() {
      result = null;
      _financialYear = FinancialYear.fy2026_27;
      _taxpayerType = TaxpayerType.salaried;
    });
  }

  Future<void> shareResult() async {
    if (result == null) return;

    await ShareService.share(
      context: context,
      title: 'CoreNaksh Finance Income Tax',
      data: {
        'Financial Year': _financialYear == FinancialYear.fy2025_26
            ? 'FY 2025-26'
            : 'FY 2026-27',
        'Taxpayer Type': _taxpayerType == TaxpayerType.salaried
            ? 'Salaried'
            : 'Non-Salaried',
        'Gross Income': formatter.format(result!.grossIncome),
        'Taxable Income': formatter.format(result!.taxableIncome),
        'Income Tax': formatter.format(result!.totalTax),
        'Cess': formatter.format(result!.cess),
        'Total Tax': formatter.format(result!.totalTax),
      },
    );
  }

  Future<void> exportPdf() async {
    if (result == null) return;

    final document = await IncomeTaxPdf.build(result: result!);

    const exporter = PdfExportService();

    await exporter.shareDocument(document);
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income Tax Calculator'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppNumberField(
                controller: _incomeController,
                label: 'Annual Income',
                decimal: true,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<FinancialYear>(
                initialValue: _financialYear,
                decoration: const InputDecoration(
                  labelText: 'Financial Year',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: FinancialYear.fy2025_26,
                    child: Text('FY 2025-26'),
                  ),
                  DropdownMenuItem(
                    value: FinancialYear.fy2026_27,
                    child: Text('FY 2026-27'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _financialYear = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<TaxpayerType>(
                initialValue: _taxpayerType,
                decoration: const InputDecoration(
                  labelText: 'Taxpayer Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: TaxpayerType.salaried,
                    child: Text('Salaried'),
                  ),
                  DropdownMenuItem(
                    value: TaxpayerType.nonSalaried,
                    child: Text('Non-Salaried'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _taxpayerType = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton.icon(
                      onPressed: result == null ? null : shareResult,
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton.icon(
                      onPressed: result == null ? null : exportPdf,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('PDF'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              if (result == null)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          child: Icon(
                            Icons.account_balance,
                            size: 42,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Income Tax Calculator",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Calculate your income tax instantly using the latest Indian income tax slabs.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),

                        const SizedBox(height: 24),

                        const Divider(),

                        const SizedBox(height: 18),

                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text("Supports FY 2025-26 & FY 2026-27"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(width: 12),
                            Expanded(child: Text("Salaried & Non-Salaried")),
                          ],
                        ),

                        const SizedBox(height: 14),

                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(width: 12),
                            Expanded(child: Text("Detailed Tax Breakdown")),
                          ],
                        ),

                        const SizedBox(height: 14),

                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(width: 12),
                            Expanded(child: Text("Share & Export PDF")),
                          ],
                        ),

                        SizedBox(height: 22),

                        Text(
                          "Enter your annual income above and tap Calculate.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                SummaryCard(
                  annualIncome: formatter.format(result!.grossIncome),
                  totalTax: formatter.format(result!.totalTax),
                  annualTakeHome: formatter.format(result!.takeHome),
                  monthlyTakeHome: formatter.format(result!.takeHome / 12),
                ),

                ResultCard(
                  title: 'Financial Year',
                  value: _financialYear == FinancialYear.fy2025_26
                      ? 'FY 2025-26'
                      : 'FY 2026-27',
                  icon: Icons.calendar_month,
                ),

                ResultCard(
                  title: 'Taxpayer Type',
                  value: _taxpayerType == TaxpayerType.salaried
                      ? 'Salaried'
                      : 'Non-Salaried',
                  icon: Icons.person,
                ),

                const SizedBox(height: 20),

                ResultCard(
                  title: 'Health & Education Cess',
                  value: formatter.format(result!.cess),
                  icon: Icons.health_and_safety,
                ),

                ResultCard(
                  title: 'Total Tax',
                  value: formatter.format(result!.totalTax),
                  icon: Icons.account_balance,
                ),

                ResultCard(
                  title: 'Annual Take Home',
                  value: formatter.format(result!.takeHome),
                  icon: Icons.account_balance_wallet,
                ),

                ResultCard(
                  title: 'Monthly Tax',
                  value: formatter.format(result!.monthlyTax),
                  icon: Icons.calendar_today,
                ),

                ResultCard(
                  title: 'Monthly Take Home',
                  value: formatter.format(result!.takeHome / 12),
                  icon: Icons.payments,
                ),

                ResultCard(
                  title: 'Effective Tax Rate',
                  value: '${result!.effectiveTaxRate.toStringAsFixed(2)}%',
                  icon: Icons.percent,
                ),

                TaxBreakdownTable(breakdown: result!.breakdown),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
