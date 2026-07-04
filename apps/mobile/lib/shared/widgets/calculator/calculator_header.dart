import 'package:flutter/material.dart';

class CalculatorHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const CalculatorHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(radius: 28, child: Icon(icon, size: 30)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  if (subtitle?.isNotEmpty ?? false) Text(subtitle!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
