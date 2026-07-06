import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String annualIncome;
  final String totalTax;
  final String annualTakeHome;
  final String monthlyTakeHome;

  const SummaryCard({
    super.key,
    required this.annualIncome,
    required this.totalTax,
    required this.annualTakeHome,
    required this.monthlyTakeHome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Summary',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _row('💰 Annual Income', annualIncome),
            _row('🏦 Total Tax', totalTax),
            _row('💵 Annual Take Home', annualTakeHome),
            _row('📅 Monthly Take Home', monthlyTakeHome),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}