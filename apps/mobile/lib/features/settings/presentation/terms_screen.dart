import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Text(
          '''
FinanceHub Terms

FinanceHub provides financial calculations for informational purposes only.

Users should verify results before making financial decisions.

FinanceHub is not a financial advisor.

© 2026 CoreNaksh Technologies
''',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}