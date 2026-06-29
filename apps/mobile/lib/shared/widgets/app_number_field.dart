import 'package:flutter/material.dart';

class AppNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool decimal;

  const AppNumberField({
    super.key,
    required this.controller,
    required this.label,
    this.decimal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(
          decimal: decimal,
        ),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          prefixIcon: const Icon(Icons.calculate),
        ),
      ),
    );
  }
}