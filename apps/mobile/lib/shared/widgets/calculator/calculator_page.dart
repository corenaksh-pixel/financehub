import 'package:financehub/shared/widgets/calculator/calculator_actions.dart';
import 'package:financehub/shared/widgets/calculator/calculator_header.dart';
import 'package:financehub/shared/widgets/calculator/calculator_result.dart';
import 'package:financehub/shared/widgets/calculator/calculator_section.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;

  final Widget inputSection;

  final List<CalculatorResultItem> results;
  final List<Widget> resultWidgets;

  final VoidCallback onCalculate;
  final VoidCallback onReset;
  final VoidCallback? onShare;
  final VoidCallback? onPdf;

  final bool enableActions;

  const CalculatorPage({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,

    required this.inputSection,

    required this.results,
    this.resultWidgets = const [],

    required this.onCalculate,
    required this.onReset,
    this.onShare,
    this.onPdf,

    this.enableActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CalculatorHeader(title: title, subtitle: subtitle, icon: icon),

                CalculatorSection(title: "Inputs", child: inputSection),

                CalculatorSection(
                  title: "Actions",
                  child: CalculatorActions(
                    onCalculate: onCalculate,
                    onReset: onReset,
                    onShare: onShare,
                  ),
                ),

                if (results.isNotEmpty)
                  CalculatorSection(
                    title: "Results",
                    child: CalculatorResult(
                      results: results,
                      children: resultWidgets,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
