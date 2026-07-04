import 'package:flutter/material.dart';

class EmptyResult extends StatelessWidget {
  const EmptyResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: const [
              Icon(Icons.calculate_outlined, size: 60),
              SizedBox(height: 12),
              Text(
                "Enter values and tap Calculate",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}