import 'package:financehub/features/emi/domain/emi_calculator.dart';
import 'package:financehub/features/emi/domain/emi_schedule.dart';
import 'package:financehub/features/emi/domain/emi_share.dart';
import 'package:financehub/features/emi/presentation/widgets/amortization_table.dart';
import 'package:financehub/shared/widgets/app_number_field.dart';
import 'package:financehub/features/emi/presentation/widgets/emi_pie_chart.dart';
import 'package:financehub/shared/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmiScreen extends StatefulWidget {
  const EmiScreen({super.key});

  @override
  State<EmiScreen> createState() => _EmiScreenState();
}

class _EmiScreenState extends State<EmiScreen> {
  final _loanController = TextEditingController();
  final _interestController = TextEditingController();
  final _tenureController = TextEditingController();

  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 2,
  );

  double? emi;
  double? totalInterest;
  double? totalPayment;

  List<EmiSchedule> schedule = [];

  void calculateEMI() {
    FocusScope.of(context).unfocus();

    final principal = double.tryParse(_loanController.text.trim());
    final annualRate = double.tryParse(_interestController.text.trim());
    final years = double.tryParse(_tenureController.text.trim());

    if (principal == null || principal <= 0) {
      _showError("Please enter a valid loan amount.");
      return;
    }

    if (annualRate == null || annualRate <= 0) {
      _showError("Please enter a valid interest rate.");
      return;
    }

    if (annualRate > 100) {
      _showError("Interest rate cannot exceed 100%.");
      return;
    }

    if (years == null || years <= 0) {
      _showError("Please enter a valid loan tenure.");
      return;
    }

    if (years > 50) {
      _showError("Loan tenure cannot exceed 50 years.");
      return;
    }

    final result = EmiCalculator.calculate(
      principal: principal,
      annualRate: annualRate,
      years: years,
    );

    final emiSchedule = EmiCalculator.generateSchedule(
      principal: principal,
      annualRate: annualRate,
      years: years,
    );

    setState(() {
      emi = result["emi"];
      totalInterest = result["interest"];
      totalPayment = result["payment"];
      schedule = emiSchedule;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void resetCalculator() {
    _loanController.clear();
    _interestController.clear();
    _tenureController.clear();

    setState(() {
      emi = null;
      totalInterest = null;
      totalPayment = null;
      schedule.clear();
    });
  }

  Future<void> shareResult() async {
    if (emi == null) return;

    await EmiShare.share(
      emi: currencyFormatter.format(emi!),
      interest: currencyFormatter.format(totalInterest!),
      payment: currencyFormatter.format(totalPayment!),
    );
  }

  @override
  void dispose() {
    _loanController.dispose();
    _interestController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EMI Calculator")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppNumberField(
                controller: _loanController,
                label: "Loan Amount",
                decimal: true,
              ),

              AppNumberField(
                controller: _interestController,
                label: "Interest Rate (%)",
                decimal: true,
              ),

              AppNumberField(
                controller: _tenureController,
                label: "Loan Tenure (Years)",
              ),

              const SizedBox(height: 20),

              FilledButton.icon(
                onPressed: calculateEMI,
                icon: const Icon(Icons.calculate),
                label: const Text("Calculate EMI"),
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
                      onPressed: emi == null ? null : shareResult,
                      icon: const Icon(Icons.share),
                      label: const Text("Share"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              if (emi != null) ...[
                ResultCard(
                  title: "Monthly EMI",
                  value: currencyFormatter.format(emi!),
                  icon: Icons.payments,
                ),

                ResultCard(
                  title: "Total Interest",
                  value: currencyFormatter.format(totalInterest!),
                  icon: Icons.trending_up,
                ),

                ResultCard(
                  title: "Total Payment",
                  value: currencyFormatter.format(totalPayment!),
                  icon: Icons.account_balance_wallet,
                ),

                const SizedBox(height: 24),

                EmiPieChart(
                  principal: double.parse(_loanController.text),
                  interest: totalInterest!,
                ),

                const SizedBox(height: 24),

                AmortizationTable(schedule: schedule),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
