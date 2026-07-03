import 'package:financehub/features/calculators/domain/calculator_catalog.dart';
import 'package:financehub/features/calculators/domain/calculator_info.dart';
import 'package:financehub/features/categories/presentation/category_screen.dart';
import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: CalculatorCategory.values.map((category) {
        final calculators = CalculatorCatalog.byCategory(category);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(_icon(category)),
              ),
              title: Text(_title(category)),
              subtitle: Text(
                '${calculators.length} Calculator${calculators.length == 1 ? '' : 's'}',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(
                      category: category,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
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

  IconData _icon(CalculatorCategory category) {
    switch (category) {
      case CalculatorCategory.loans:
        return Icons.account_balance;
      case CalculatorCategory.investment:
        return Icons.trending_up;
      case CalculatorCategory.tax:
        return Icons.receipt_long;
      case CalculatorCategory.savings:
        return Icons.savings;
    }
  }
}