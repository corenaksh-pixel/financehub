import 'package:financehub/core/services/pdf_service.dart';
import 'package:financehub/core/services/share_service.dart';
import 'package:financehub/features/sip/domain/sip_calculator.dart';
import 'package:financehub/shared/widgets/app_number_field.dart';
import 'package:financehub/shared/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:financehub/core/services/history_service.dart';

class SipScreen extends StatefulWidget {
  const SipScreen({super.key});

  @override
  State<SipScreen> createState() => _SipScreenState();
}

class _SipScreenState extends State<SipScreen> {
  final _investmentController = TextEditingController();
  final _returnController = TextEditingController(text: '12');
  final _yearsController = TextEditingController();

  final NumberFormat formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 2,
  );

  double? investedAmount;
  double? estimatedReturns;
  double? maturityValue;

  Future<void> calculateSIP() async {
    FocusScope.of(context).unfocus();

    final investment = double.tryParse(_investmentController.text.trim());
    final annualReturn = double.tryParse(_returnController.text.trim());
    final years = double.tryParse(_yearsController.text.trim());

    if (investment == null || investment <= 0) {
      _showError("Please enter a valid monthly investment.");
      return;
    }

    if (annualReturn == null || annualReturn < 0 || annualReturn > 100) {
      _showError("Please enter a valid expected return.");
      return;
    }

    if (years == null || years <= 0) {
      _showError("Please enter a valid investment period.");
      return;
    }

    final result = SipCalculator.calculate(
      monthlyInvestment: investment,
      annualReturn: annualReturn,
      years: years,
    );

    setState(() {
      investedAmount = result['investedAmount'];
      estimatedReturns = result['estimatedReturns'];
      maturityValue = result['maturityValue'];
    });
    await HistoryService.save(
      calculator: 'SIP',
      inputs: {
        'Monthly Investment': investment,
        'Expected Return (%)': annualReturn,
        'Investment Period (Years)': years,
      },
      results: {
        'Total Invested': investedAmount!,
        'Estimated Returns': estimatedReturns!,
        'Maturity Value': maturityValue!,
      },
    );
  }

  void resetCalculator() {
    _investmentController.clear();
    _returnController.text = '12';
    _yearsController.clear();

    setState(() {
      investedAmount = null;
      estimatedReturns = null;
      maturityValue = null;
    });
  }

  Future<void> shareResult() async {
    if (maturityValue == null) return;

    await ShareService.share(
      context: context,
      title: 'CoreNaksh Finance SIP Calculation',
      data: {
        'Monthly Investment': formatter.format(
          double.parse(_investmentController.text),
        ),
        'Expected Return': '${_returnController.text}%',
        'Investment Period': '${_yearsController.text} Years',
        'Total Invested': formatter.format(investedAmount!),
        'Estimated Returns': formatter.format(estimatedReturns!),
        'Maturity Value': formatter.format(maturityValue!),
      },
    );
  }

  Future<void> exportPdf() async {
    if (maturityValue == null) return;

    await PdfService.generateReport(
      title: 'CoreNaksh Finance SIP Report',
      data: {
        'Monthly Investment': formatter.format(
          double.parse(_investmentController.text),
        ),
        'Expected Return': '${_returnController.text}%',
        'Investment Period': '${_yearsController.text} Years',
        'Total Invested': formatter.format(investedAmount!),
        'Estimated Returns': formatter.format(estimatedReturns!),
        'Maturity Value': formatter.format(maturityValue!),
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
    _investmentController.dispose();
    _returnController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SIP Calculator"), centerTitle: true),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppNumberField(
                controller: _investmentController,
                label: "Monthly Investment",
                decimal: true,
              ),

              const SizedBox(height: 16),

              AppNumberField(
                controller: _returnController,
                label: "Expected Annual Return (%)",
                decimal: true,
              ),

              const SizedBox(height: 16),

              AppNumberField(
                controller: _yearsController,
                label: "Investment Period (Years)",
              ),

              const SizedBox(height: 20),

              FilledButton.icon(
                onPressed: calculateSIP,
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
                      onPressed: maturityValue == null ? null : shareResult,
                      icon: const Icon(Icons.share),
                      label: const Text("Share"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton.icon(
                      onPressed: maturityValue == null ? null : exportPdf,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("PDF"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              if (maturityValue == null)
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
                            Icons.savings,
                            size: 42,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "SIP Calculator",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Estimate your wealth by investing monthly using the power of compounding.",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Divider(),
                        const SizedBox(height: 18),
                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(width: 12),
                            Expanded(child: Text("Monthly SIP Investment")),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(width: 12),
                            Expanded(child: Text("Expected Annual Return")),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(width: 12),
                            Expanded(child: Text("Investment Period")),
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
                        const SizedBox(height: 22),
                        Text(
                          "Enter the details above and tap Calculate.",
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
                ResultCard(
                  title: "Total Invested",
                  value: formatter.format(investedAmount!),
                  icon: Icons.savings,
                ),
                ResultCard(
                  title: "Estimated Returns",
                  value: formatter.format(estimatedReturns!),
                  icon: Icons.trending_up,
                ),
                ResultCard(
                  title: "Maturity Value",
                  value: formatter.format(maturityValue!),
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
