import 'package:financehub/features/calculators/domain/calculator_catalog.dart';
import 'package:financehub/shared/widgets/calculator_card.dart';
import 'package:flutter/material.dart';

class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculators = CalculatorCatalog.calculators;

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Calculators"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: calculators.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final calculator = calculators[index];

          return CalculatorCard(
            id: calculator.id,
            icon: calculator.icon,
            title: calculator.title,
            subtitle: calculator.subtitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => calculator.screen,
                ),
              );
            },
          );
        },
      ),
    );
  }
}