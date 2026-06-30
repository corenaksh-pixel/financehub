import 'package:flutter/material.dart';

class AppNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool decimal;
  final TextInputAction textInputAction;

  const AppNumberField({
    super.key,
    required this.controller,
    required this.label,
    this.decimal = false,
    this.textInputAction = TextInputAction.next,
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
        textInputAction: textInputAction,
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: "Enter $label",
          prefixIcon: const Icon(Icons.calculate),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}