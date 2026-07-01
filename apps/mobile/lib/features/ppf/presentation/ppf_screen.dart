import 'package:financehub/core/services/pdf_service.dart';
import 'package:financehub/core/services/share_service.dart';
import 'package:financehub/features/ppf/domain/ppf_calculator.dart';
import 'package:financehub/shared/widgets/app_number_field.dart';
import 'package:financehub/shared/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PpfScreen extends StatefulWidget {
  const PpfScreen({super.key});

  @override
  State<PpfScreen> createState() => _PpfScreenState();
}

class _PpfScreenState extends State<PpfScreen> {
  final _investmentController = TextEditingController();
  final _rateController = TextEditingController(text: '7.1');
  final _yearsController = TextEditingController(text: '15');

  final NumberFormat formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 2,
  );

  double? invested;
  double? interest;
  double? maturity;

  void calculatePPF() {
    FocusScope.of(context).unfocus();

    final investment =
        double.tryParse(_investmentController.text.trim());
    final rate =
        double.tryParse(_rateController.text.trim());
    final years =
        int.tryParse(_yearsController.text.trim());

    if (investment == null || investment <= 0) {
      _showError("Please enter a valid yearly investment.");
      return;
    }

    if (rate == null || rate < 0 || rate > 100) {
      _showError("Please enter a valid interest rate.");
      return;
    }

    if (years == null || years <= 0) {
      _showError("Please enter a valid investment period.");
      return;
    }

    final result = PpfCalculator.calculate(
      yearlyInvestment: investment,
      annualRate: rate,
      years: years,
    );

    setState(() {
      invested = result["invested"];
      interest = result["interest"];
      maturity = result["maturity"];
    });
  }

  void resetCalculator() {
    _investmentController.clear();
    _rateController.text = '7.1';
    _yearsController.text = '15';

    setState(() {
      invested = null;
      interest = null;
      maturity = null;
    });
  }

  Future<void> shareResult() async {
    if (maturity == null) return;

    await ShareService.share(
      context: context,
      title: 'FinanceHub PPF Calculation',
      data: {
        'Yearly Investment':
            formatter.format(double.parse(_investmentController.text)),
        'Interest Earned': formatter.format(interest!),
        'Total Investment': formatter.format(invested!),
        'Maturity Amount': formatter.format(maturity!),
      },
    );
  }

  Future<void> exportPdf() async {
    if (maturity == null) return;

    await PdfService.generateReport(
      title: 'FinanceHub PPF Report',
      data: {
        'Yearly Investment':
            formatter.format(double.parse(_investmentController.text)),
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
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  void dispose() {
    _investmentController.dispose();
    _rateController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PPF Calculator"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppNumberField(
                controller: _investmentController,
                label: "Yearly Investment",
                decimal: true,
              ),

              AppNumberField(
                controller: _rateController,
                label: "Interest Rate (%)",
                decimal: true,
              ),

              AppNumberField(
                controller: _yearsController,
                label: "Investment Period (Years)",
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: calculatePPF,
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