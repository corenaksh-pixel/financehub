import 'package:financehub/core/services/pdf_service.dart';
import 'package:financehub/core/services/share_service.dart';
import 'package:financehub/features/fd/domain/fd_calculator.dart';
import 'package:financehub/shared/widgets/app_number_field.dart';
import 'package:financehub/shared/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:financehub/core/services/history_service.dart';

class FdScreen extends StatefulWidget {
  const FdScreen({super.key});

  @override
  State<FdScreen> createState() => _FdScreenState();
}

class _FdScreenState extends State<FdScreen> {
  final _principalController = TextEditingController();
  final _rateController = TextEditingController(text: "7.5");
  final _yearsController = TextEditingController();

  final NumberFormat formatter = NumberFormat.currency(
    locale: "en_IN",
    symbol: "₹ ",
    decimalDigits: 2,
  );

  final Map<String, int> compoundingOptions = {
    "Yearly": 1,
    "Half-Yearly": 2,
    "Quarterly": 4,
    "Monthly": 12,
  };

  String selectedCompounding = "Yearly";

  double? principal;
  double? interest;
  double? maturity;

  Future<void> calculateFD() async {
    FocusScope.of(context).unfocus();

    final amount = double.tryParse(_principalController.text.trim());
    final rate = double.tryParse(_rateController.text.trim());
    final years = double.tryParse(_yearsController.text.trim());

    if (amount == null || amount <= 0) {
      _showError("Please enter a valid deposit amount.");
      return;
    }

    if (rate == null || rate < 0 || rate > 100) {
      _showError("Please enter a valid interest rate.");
      return;
    }

    if (years == null || years <= 0) {
      _showError("Please enter a valid tenure.");
      return;
    }

    final result = FdCalculator.calculate(
      principal: amount,
      annualRate: rate,
      years: years,
      compoundsPerYear: compoundingOptions[selectedCompounding]!,
    );

    setState(() {
      principal = result["principal"];
      interest = result["interest"];
      maturity = result["maturity"];
    });
    await HistoryService.save(
      calculator: 'FD',
      inputs: {
        'Deposit Amount': amount,
        'Interest Rate (%)': rate,
        'Tenure (Years)': years,
        'Compounding': selectedCompounding,
      },
      results: {
        'Deposit Amount': principal!,
        'Interest Earned': interest!,
        'Maturity Amount': maturity!,
      },
    );
  }

  void resetCalculator() {
    _principalController.clear();
    _rateController.text = "7.5";
    _yearsController.clear();

    setState(() {
      principal = null;
      interest = null;
      maturity = null;
      selectedCompounding = "Yearly";
    });
  }

  Future<void> shareResult() async {
    if (maturity == null) return;

    await ShareService.share(
      context: context,
      title: "CoreNaksh Finance FD Calculation",
      data: {
        "Deposit": formatter.format(principal!),
        "Interest": formatter.format(interest!),
        "Maturity": formatter.format(maturity!),
      },
    );
  }

  Future<void> exportPdf() async {
    if (maturity == null) return;

    await PdfService.generateReport(
      title: "CoreNaksh Finance FD Report",
      data: {
        "Deposit": formatter.format(principal!),
        "Interest": formatter.format(interest!),
        "Maturity": formatter.format(maturity!),
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
    _principalController.dispose();
    _rateController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FD Calculator")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppNumberField(
                controller: _principalController,
                label: "Deposit Amount",
                decimal: true,
              ),

              AppNumberField(
                controller: _rateController,
                label: "Interest Rate (%)",
                decimal: true,
              ),

              AppNumberField(
                controller: _yearsController,
                label: "Tenure (Years)",
                decimal: true,
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
                onPressed: calculateFD,
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
                  title: "Deposit Amount",
                  value: formatter.format(principal!),
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
