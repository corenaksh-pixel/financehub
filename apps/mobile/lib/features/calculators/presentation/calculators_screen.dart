import 'package:financehub/features/emi/presentation/emi_screen.dart';
import 'package:flutter/material.dart';

class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({super.key});

  final List<Map<String, dynamic>> calculators = const [
    {"title": "EMI Calculator", "icon": Icons.account_balance},
    {"title": "GST Calculator", "icon": Icons.receipt_long},
    {"title": "SIP Calculator", "icon": Icons.trending_up},
    {"title": "FD Calculator", "icon": Icons.savings},
    {"title": "RD Calculator", "icon": Icons.payments},
    {"title": "PPF Calculator", "icon": Icons.account_balance_wallet},
    {"title": "Loan Eligibility", "icon": Icons.request_page},
    {"title": "Income Tax", "icon": Icons.calculate},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculators"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: calculators.length,
        itemBuilder: (context, index) {
          final calculator = calculators[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                calculator["icon"],
                size: 32,
              ),
              title: Text(
                calculator["title"],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                if (calculator["title"] == "EMI Calculator") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmiScreen(),
                    ),
                  );
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "${calculator["title"]} coming soon",
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}