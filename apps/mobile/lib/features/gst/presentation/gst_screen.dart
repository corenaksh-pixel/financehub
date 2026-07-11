import 'package:financehub/core/services/pdf_service.dart';
import 'package:financehub/core/services/share_service.dart';
import 'package:financehub/features/gst/domain/gst_calculator.dart';
import 'package:financehub/shared/widgets/app_number_field.dart';
import 'package:financehub/shared/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:financehub/core/services/history_service.dart';

class GstScreen extends StatefulWidget {
  const GstScreen({super.key});

  @override
  State<GstScreen> createState() => _GstScreenState();
}

class _GstScreenState extends State<GstScreen> {
  final _amountController = TextEditingController();
  double gstRate = 18;
  double? cgst;
  double? sgst;
  final NumberFormat formatter = NumberFormat.currency(
    locale: "en_IN",
    symbol: "₹ ",
    decimalDigits: 2,
  );

  bool isAddGst = true;

  double? baseAmount;
  double? gstAmount;
  double? finalAmount;

  Future<void> calculateGST() async {
    FocusScope.of(context).unfocus();

    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null || amount <= 0) {
      _showError("Please enter a valid amount.");
      return;
    }

    final gst = gstRate;

    final result = GstCalculator.calculate(
      amount: amount,
      gstRate: gst,
      isAddGst: isAddGst,
    );

    setState(() {
      baseAmount = result["baseAmount"];
      gstAmount = result["gstAmount"];
      finalAmount = result["finalAmount"];

      cgst = gstAmount! / 2;
      sgst = gstAmount! / 2;
    });
    await HistoryService.save(
      calculator: 'GST',
      inputs: {
        'Amount': amount,
        'GST %': gst,
        'Mode': isAddGst ? 'Add GST' : 'Remove GST',
      },
      results: {
        'Base Amount': baseAmount!,
        'GST Rate': gstRate,
        'GST Amount': gstAmount!,
        'CGST': cgst!,
        'SGST': sgst!,
        'Final Amount': finalAmount!,
      },
    );
  }

  void reset() {
    _amountController.clear();
    gstRate = 18;
    cgst = null;
    sgst = null;

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
      context: context,
      title: "CoreNaksh Finance GST Calculation",
      data: {
        "Mode": isAddGst ? "Add GST" : "Remove GST",

        "GST Rate": "${gstRate.toStringAsFixed(0)}%",

        "Base Amount": formatter.format(baseAmount!),

        "GST Amount": formatter.format(gstAmount!),

        "CGST": formatter.format(cgst!),

        "SGST": formatter.format(sgst!),

        "Final Amount": formatter.format(finalAmount!),
      },
    );
  }

  Future<void> exportPdf() async {
    if (baseAmount == null) return;

    await PdfService.generateReport(
      title: "CoreNaksh Finance GST Report",
      data: {
        "Mode": isAddGst ? "Add GST" : "Remove GST",
        "GST Rate": "${gstRate.toStringAsFixed(0)}%",
        "Base Amount": formatter.format(baseAmount!),
        "GST Amount": formatter.format(gstAmount!),
        "CGST": formatter.format(cgst!),
        "SGST": formatter.format(sgst!),
        "Final Amount": formatter.format(finalAmount!),
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GST Calculator"), centerTitle: true),
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

              const SizedBox(height: 16),
              DropdownButtonFormField<double>(
                initialValue: gstRate,
                decoration: const InputDecoration(
                  labelText: 'GST Rate',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 3, child: Text('3%')),
                  DropdownMenuItem(value: 5, child: Text('5%')),
                  DropdownMenuItem(value: 12, child: Text('12%')),
                  DropdownMenuItem(value: 18, child: Text('18%')),
                  DropdownMenuItem(value: 28, child: Text('28%')),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    gstRate = value;
                  });
                },
              ),

              const SizedBox(height: 16),

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
                      onPressed: baseAmount == null ? null : share,
                      icon: const Icon(Icons.share),
                      label: const Text("Share"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton.icon(
                      onPressed: baseAmount == null ? null : exportPdf,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("PDF"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              if (baseAmount == null) ...[
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long, size: 56, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          "Enter amount, select GST rate and tap Calculate.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                ResultCard(
                  title: "Base Amount",
                  value: formatter.format(baseAmount!),
                  icon: Icons.account_balance_wallet,
                ),
                ResultCard(
                  title: "GST Rate",
                  value: "${gstRate.toStringAsFixed(0)} %",
                  icon: Icons.percent,
                ),
                ResultCard(
                  title: "GST Amount",
                  value: formatter.format(gstAmount!),
                  icon: Icons.receipt_long,
                ),
                ResultCard(
                  title: "CGST",
                  value: formatter.format(cgst!),
                  icon: Icons.account_balance,
                ),
                ResultCard(
                  title: "SGST",
                  value: formatter.format(sgst!),
                  icon: Icons.account_balance,
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
