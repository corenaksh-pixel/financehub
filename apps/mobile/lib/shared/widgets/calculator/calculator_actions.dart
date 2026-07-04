import 'package:flutter/material.dart';

class CalculatorActions extends StatelessWidget {
  final VoidCallback onCalculate;
  final VoidCallback onReset;
  final VoidCallback? onShare;

  const CalculatorActions({
    super.key,
    required this.onCalculate,
    required this.onReset,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          onPressed: onCalculate,
          child: const Text("Calculate"),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onReset,
                child: const Text("Reset"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: onShare,
                child: const Text("Share"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}