import 'package:flutter/material.dart';

class CalculatorActionBar extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onShare;
  final VoidCallback onPdf;

  const CalculatorActionBar({
    super.key,
    required this.onReset,
    required this.onShare,
    required this.onPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: onShare,
          icon: const Icon(Icons.share),
          label: const Text("Share"),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: onPdf,
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text("Export PDF"),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.refresh),
          label: const Text("Reset"),
        ),
      ],
    );
  }
}