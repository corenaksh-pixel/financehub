import 'package:financehub/core/services/pdf_service.dart';
import 'package:financehub/core/services/share_service.dart';
import 'package:financehub/features/rd/domain/rd_calculator.dart';
import 'package:financehub/shared/widgets/app_number_field.dart';
import 'package:financehub/shared/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:financehub/core/services/history_service.dart';

class RdScreen extends StatefulWidget {
  const RdScreen({super.key});

  @override
  State<RdScreen> createState() => _RdScreenState();
}

class _RdScreenState extends State<RdScreen> {
  final _depositController = TextEditingController();
  final _rateController = TextEditingController(text: '7.5');
  final _monthsController = TextEditingController();

  final NumberFormat formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 2,
  );

  final Map<String, int> compoundingOptions = {
    'Monthly': 12,
    'Quarterly': 4,
    'Half-Yearly': 2,
    'Yearly': 1,
  };

  String selectedCompounding = 'Monthly';

  double? invested;
  double? interest;
  double? maturity;

  Future<void> calculateRD() async {
    FocusScope.of(context).unfocus();

    final deposit = double.tryParse(_depositController.text.trim());
    final rate = double.tryParse(_rateController.text.trim());
    final months = int.tryParse(_monthsController.text.trim());

    if (deposit == null || deposit <= 0) {
      _showError("Please enter a valid monthly deposit.");
      return;
    }

    if (rate == null || rate < 0 || rate > 100) {
      _showError("Please enter a valid interest rate.");
      return;
    }

    if (months == null || months <= 0) {
      _showError("Please enter a valid tenure.");
      return;
    }

    final result = RdCalculator.calculate(
      monthlyDeposit: deposit,
      annualRate: rate,
      months: months,
      compoundsPerYear: compoundingOptions[selectedCompounding]!,
    );

    setState(() {
      invested = result["invested"];
      interest = result["interest"];
      maturity = result["maturity"];
    });

    await HistoryService.save(
      calculator: 'RD',
      inputs: {
        'Monthly Deposit': deposit,
        'Interest Rate (%)': rate,
        'Tenure (Months)': months,
        'Compounding': selectedCompounding,
      },
      results: {
        'Total Investment': invested!,
        'Interest Earned': interest!,
        'Maturity Amount': maturity!,
      },
    );
  }

  void resetCalculator() {
    _depositController.clear();
    _rateController.text = '7.5';
    _monthsController.clear();

    setState(() {
      invested = null;
      interest = null;
      maturity = null;
      selectedCompounding = 'Monthly';
    });
  }

  Future<void> shareResult() async {
    if (maturity == null) return;

    await ShareService.share(
      context: context,
      title: 'CoreNaksh Finance RD Calculation',
      data: {
        'Monthly Deposit': formatter.format(
          double.parse(_depositController.text),
        ),
        'Interest Earned': formatter.format(interest!),
        'Total Investment': formatter.format(invested!),
        'Maturity Amount': formatter.format(maturity!),
      },
    );
  }

  Future<void> exportPdf() async {
    if (maturity == null) return;

    await PdfService.generateReport(
      title: 'CoreNaksh Finance RD Report',
      data: {
        'Monthly Deposit': formatter.format(
          double.parse(_depositController.text),
        ),
        'Interest Earned': formatter.format(interest!),
        'Total Investment': formatter.format(invested!),
        'Maturity Amount': formatter.format(maturity!),
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
  }

  @override
  void dispose() {
    _depositController.dispose();
    _rateController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("RD Calculator")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppNumberField(
                controller: _depositController,
                label: "Monthly Deposit",
                decimal: true,
              ),

              AppNumberField(
                controller: _rateController,
                label: "Interest Rate (%)",
                decimal: true,
              ),

              AppNumberField(
                controller: _monthsController,
                label: "Tenure (Months)",
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                initialValue: selectedCompounding,
                decoration: const InputDecoration(
                  labelText: "Compounding",
                  border: OutlineInputBorder(),
                ),
                items: compoundingOptions.keys.map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCompounding = value!;
                  });
                },
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: calculateRD,
                icon: const Icon(Icons.calculate),
                label: const Text("Calculate"),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: resetCalculator,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Reset"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: maturity == null ? null : shareResult,
                      icon: const Icon(Icons.share),
                      label: const Text("Share"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: maturity == null ? null : exportPdf,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("PDF"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              if (maturity != null) ...[
                ResultCard(
                  title: "Total Investment",
                  value: formatter.format(invested!),
                  icon: Icons.savings,
                ),
                ResultCard(
                  title: "Interest Earned",
                  value: formatter.format(interest!),
                  icon: Icons.trending_up,
                ),
                ResultCard(
                  title: "Maturity Amount",
                  value: formatter.format(maturity!),
                  icon: Icons.account_balance_wallet,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
