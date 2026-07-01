import 'package:financehub/core/services/pdf_service.dart';
import 'package:financehub/core/services/share_service.dart';
import 'package:financehub/features/gst/domain/gst_calculator.dart';
import 'package:financehub/shared/widgets/app_number_field.dart';
import 'package:financehub/shared/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GstScreen extends StatefulWidget {
  const GstScreen({super.key});

  @override
  State<GstScreen> createState() => _GstScreenState();
}

class _GstScreenState extends State<GstScreen> {
  final _amountController = TextEditingController();
  final _gstController = TextEditingController(text: "18");

  final NumberFormat formatter = NumberFormat.currency(
    locale: "en_IN",
    symbol: "₹ ",
    decimalDigits: 2,
  );

  bool isAddGst = true;

  double? baseAmount;
  double? gstAmount;
  double? finalAmount;

  void calculateGST() {
    FocusScope.of(context).unfocus();

    final amount = double.tryParse(_amountController.text.trim());
    final gst = double.tryParse(_gstController.text.trim());

    if (amount == null || amount <= 0) {
      _showError("Please enter a valid amount.");
      return;
    }

    if (gst == null || gst < 0 || gst > 100) {
      _showError("Please enter a valid GST percentage.");
      return;
    }

    final result = GstCalculator.calculate(
      amount: amount,
      gstRate: gst,
      isAddGst: isAddGst,
    );

    setState(() {
      baseAmount = result["baseAmount"];
      gstAmount = result["gstAmount"];
      finalAmount = result["finalAmount"];
    });
  }

  void reset() {
    _amountController.clear();
    _gstController.text = "18";

    setState(() {
      baseAmount = null;
      gstAmount = null;
      finalAmount = null;
      isAddGst = true;
    });
  }

  Future<void> share() async {
    if (baseAmount == null) return;

    await ShareService.share(
      title: "FinanceHub GST Calculation",
      data: {
        "Base Amount": formatter.format(baseAmount!),
        "GST Amount": formatter.format(gstAmount!),
        "Final Amount": formatter.format(finalAmount!),
      },
    );
  }

  Future<void> exportPdf() async {
    if (baseAmount == null) return;

    await PdfService.generateReport(
      title: "FinanceHub GST Report",
      data: {
        "Base Amount": formatter.format(baseAmount!),
        "GST Amount": formatter.format(gstAmount!),
        "Final Amount": formatter.format(finalAmount!),
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GST Calculator"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppNumberField(
                controller: _amountController,
                label: "Amount",
                decimal: true,
              ),

              AppNumberField(
                controller: _gstController,
                label: "GST %",
                decimal: true,
              ),

              const SizedBox(height: 10),

              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: true,
                    label: Text("Add GST"),
                    icon: Icon(Icons.add),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text("Remove GST"),
                    icon: Icon(Icons.remove),
                  ),
                ],
                selected: {isAddGst},
                onSelectionChanged: (value) {
                  setState(() {
                    isAddGst = value.first;
                  });
                },
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: calculateGST,
                icon: const Icon(Icons.calculate),
                label: const Text("Calculate"),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Reset"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton.icon(
                      onPressed:
                          baseAmount == null ? null : share,
                      icon: const Icon(Icons.share),
                      label: const Text("Share"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton.icon(
                      onPressed:
                          baseAmount == null ? null : exportPdf,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("PDF"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              if (baseAmount != null) ...[
                ResultCard(
                  title: "Base Amount",
                  value: formatter.format(baseAmount!),
                  icon: Icons.account_balance_wallet,
                ),

                ResultCard(
                  title: "GST Amount",
                  value: formatter.format(gstAmount!),
                  icon: Icons.receipt_long,
                ),

                ResultCard(
                  title: "Final Amount",
                  value: formatter.format(finalAmount!),
                  icon: Icons.payments,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}