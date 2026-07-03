import 'package:flutter/material.dart';

enum CalculatorCategory {
  loans,
  investment,
  tax,
  savings,
}

class CalculatorInfo {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final CalculatorCategory category;
  final bool popular;
  final Widget screen;

  const CalculatorInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.category,
    required this.popular,
    required this.screen,
  });
}