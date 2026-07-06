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
          financialYear: FinancialYear.fy2026_27,
          taxpayerType: TaxpayerType.salaried,
        ),
      );
    });

    await HistoryService.save(
      calculator: 'Income Tax',
      inputs: {'Annual Income': income, 'Tax Regime': 'New Regime FY 2026-27'},
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
    });
  }

  Future<void> shareResult() async {
    if (result == null) return;

    await ShareService.share(
      context: context,
      title: 'FinanceHub Income Tax',
      data: {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Income Tax Calculator')),
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

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                initialValue: 'New Regime FY 2026-27',
                decoration: const InputDecoration(
                  labelText: 'Tax Regime',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'New Regime FY 2026-27',
                    child: Text('New Regime FY 2026-27'),
                  ),
                ],
                onChanged: (_) {},
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

              if (result != null) ...[
                SummaryCard(
                  annualIncome: formatter.format(result!.grossIncome),
                  totalTax: formatter.format(result!.totalTax),
                  annualTakeHome: formatter.format(result!.takeHome),
                  monthlyTakeHome: formatter.format(result!.takeHome / 12),
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
