import 'package:financehub/features/emi/domain/emi_calculator.dart';
import 'package:financehub/shared/widgets/app_number_field.dart';
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

  void calculateEMI() {
    final principal = double.tryParse(_loanController.text);
    final annualRate = double.tryParse(_interestController.text);
    final years = double.tryParse(_tenureController.text);

    if (principal == null || annualRate == null || years == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid values"),
        ),
      );
      return;
    }

    final result = EmiCalculator.calculate(
      principal: principal,
      annualRate: annualRate,
      years: years,
    );

    setState(() {
      emi = result["emi"];
      totalInterest = result["interest"];
      totalPayment = result["payment"];
    });
  }

  void resetCalculator() {
    _loanController.clear();
    _interestController.clear();
    _tenureController.clear();

    setState(() {
      emi = null;
      totalInterest = null;
      totalPayment = null;
    });
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
      appBar: AppBar(
        title: const Text("EMI Calculator"),
      ),
      body: SingleChildScrollView(
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
            OutlinedButton.icon(
              onPressed: resetCalculator,
              icon: const Icon(Icons.refresh),
              label: const Text("Reset"),
            ),
            const SizedBox(height: 30),
            if (emi != null) ...[
              ResultCard(
                title: "Monthly EMI",
                value: currencyFormatter.format(emi),
              ),
              ResultCard(
                title: "Total Interest",
                value: currencyFormatter.format(totalInterest),
              ),
              ResultCard(
                title: "Total Payment",
                value: currencyFormatter.format(totalPayment),
              ),
            ],
          ],
        ),
      ),
    );
  }
}