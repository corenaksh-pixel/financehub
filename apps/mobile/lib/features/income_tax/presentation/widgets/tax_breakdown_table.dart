import 'package:financehub/features/income_tax/domain/tax_breakdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaxBreakdownTable extends StatelessWidget {
  final List<TaxBreakdown> breakdown;

  const TaxBreakdownTable({
    super.key,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    if (breakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 2,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(top: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tax Slab Breakdown',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            ...breakdown.map(
              (item) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildRow(
                        'Slab',
                        item.slab,
                      ),
                      _buildRow(
                        'Rate',
                        '${item.rate.toStringAsFixed(0)}%',
                      ),
                      _buildRow(
                        'Taxable Amount',
                        formatter.format(item.taxableAmount),
                      ),
                      _buildRow(
                        'Tax',
                        formatter.format(item.tax),
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String title,
    String value, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}