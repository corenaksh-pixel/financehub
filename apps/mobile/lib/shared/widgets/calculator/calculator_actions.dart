import 'package:flutter/material.dart';

class CalculatorActions extends StatelessWidget {
  final VoidCallback onCalculate;
  final VoidCallback onReset;
  final VoidCallback? onShare;
  final VoidCallback? onPdf;

  final String calculateText;
  final bool enabled;

  const CalculatorActions({
    super.key,
    required this.onCalculate,
    required this.onReset,
    this.onShare,
    this.onPdf,
    this.calculateText = "Calculate",
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onCalculate,
            icon: const Icon(Icons.calculate),
            label: Text(calculateText),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.refresh),
                label: const Text("Reset"),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: FilledButton.icon(
                onPressed: enabled ? onShare : null,
                icon: const Icon(Icons.share),
                label: const Text("Share"),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: FilledButton.icon(
                onPressed: enabled ? onPdf : null,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("PDF"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}