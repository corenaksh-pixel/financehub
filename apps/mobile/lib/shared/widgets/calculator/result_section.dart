import 'package:flutter/material.dart';

class ResultSection extends StatelessWidget {
  final List<Widget> children;

  const ResultSection({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }
}