import 'package:financehub/core/services/pdf_service.dart';
import 'package:financehub/core/services/share_service.dart';
import 'package:financehub/features/sip/domain/sip_calculator.dart';
import 'package:financehub/shared/widgets/app_number_field.dart';
import 'package:financehub/shared/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  void calculateSIP() {
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
      title: 'FinanceHub SIP Calculation',
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
      title: 'FinanceHub SIP Report',
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
      appBar: AppBar(title: const Text("SIP Calculator")),
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

              AppNumberField(
                controller: _returnController,
                label: "Expected Annual Return (%)",
                decimal: true,
              ),

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

              if (maturityValue != null) ...[
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
