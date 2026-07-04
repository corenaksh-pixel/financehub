import 'package:flutter/material.dart';

class FinanceTipCard extends StatelessWidget {
  const FinanceTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lightbulb,
              color: Colors.amber,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Finance Tip",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Invest consistently. Time in the market is usually more powerful than trying to time the market.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}