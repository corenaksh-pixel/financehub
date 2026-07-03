import 'package:financehub/features/calculators/domain/calculator_catalog.dart';
import 'package:financehub/features/calculators/domain/calculator_info.dart';
import 'package:financehub/shared/widgets/calculator_card.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final CalculatorCategory category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final calculators = CalculatorCatalog.byCategory(category);

    return Scaffold(
      appBar: AppBar(title: Text(_title(category))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
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
                  MaterialPageRoute(builder: (_) => calculator.screen),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _title(CalculatorCategory category) {
    switch (category) {
      case CalculatorCategory.loans:
        return 'Loans';

      case CalculatorCategory.investment:
        return 'Investments';

      case CalculatorCategory.tax:
        return 'Tax';

      case CalculatorCategory.savings:
        return 'Savings';
    }
  }
}
