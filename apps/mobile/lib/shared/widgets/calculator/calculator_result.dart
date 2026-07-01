import 'package:financehub/shared/widgets/result_card.dart';
import 'package:flutter/material.dart';

class CalculatorResultItem {
  final String title;
  final String value;
  final IconData icon;

  const CalculatorResultItem({
    required this.title,
    required this.value,
    required this.icon,
  });
}

class CalculatorResult extends StatelessWidget {
  final List<CalculatorResultItem> results;
  final List<Widget> children;

  const CalculatorResult({
    super.key,
    required this.results,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...results.map(
          (item) => ResultCard(
            title: item.title,
            value: item.value,
            icon: item.icon,
          ),
        ),

        if (children.isNotEmpty) ...[
          const SizedBox(height: 24),
          ...children,
        ],
      ],
    );
  }
}