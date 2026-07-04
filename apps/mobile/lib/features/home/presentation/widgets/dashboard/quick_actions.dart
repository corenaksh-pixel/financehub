import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.calculate),
                  SizedBox(height: 8),
                  Text("Calculators"),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.history),
                  SizedBox(height: 8),
                  Text("History"),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.favorite),
                  SizedBox(height: 8),
                  Text("Favorites"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}