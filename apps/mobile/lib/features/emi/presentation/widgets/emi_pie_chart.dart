import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmiPieChart extends StatelessWidget {
  final double principal;
  final double interest;

  const EmiPieChart({
    super.key,
    required this.principal,
    required this.interest,
  });

  @override
  Widget build(BuildContext context) {
    final total = principal + interest;

    final principalPercentage = (principal / total) * 100;
    final interestPercentage = (interest / total) * 100;

    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 2,
    );

    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "EMI Breakdown",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 55,
                  sectionsSpace: 3,
                  sections: [
                    PieChartSectionData(
                      value: principal,
                      color: primary,
                      radius: 65,
                      title:
                          "${principalPercentage.toStringAsFixed(1)}%",
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: interest,
                      color: secondary,
                      radius: 65,
                      title:
                          "${interestPercentage.toStringAsFixed(1)}%",
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            _LegendTile(
              color: primary,
              title: "Principal",
              amount: formatter.format(principal),
            ),

            const SizedBox(height: 12),

            _LegendTile(
              color: secondary,
              title: "Interest",
              amount: formatter.format(interest),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendTile extends StatelessWidget {
  final Color color;
  final String title;
  final String amount;

  const _LegendTile({
    required this.color,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: color,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}