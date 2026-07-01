import 'package:financehub/features/emi/presentation/emi_screen.dart';
import 'package:financehub/features/gst/presentation/gst_screen.dart';
import 'package:flutter/material.dart';

class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({super.key});

  static const List<Map<String, dynamic>> calculators = [
    {
      "title": "EMI Calculator",
      "icon": Icons.account_balance,
      "implemented": true,
    },
    {
      "title": "GST Calculator",
      "icon": Icons.receipt_long,
      "implemented": true,
    },
    {
      "title": "SIP Calculator",
      "icon": Icons.trending_up,
      "implemented": false,
    },
    {
      "title": "FD Calculator",
      "icon": Icons.savings,
      "implemented": false,
    },
    {
      "title": "RD Calculator",
      "icon": Icons.payments,
      "implemented": false,
    },
    {
      "title": "PPF Calculator",
      "icon": Icons.account_balance_wallet,
      "implemented": false,
    },
    {
      "title": "Income Tax Calculator",
      "icon": Icons.calculate,
      "implemented": false,
    },
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
                calculator["icon"] as IconData,
                size: 32,
              ),
              title: Text(
                calculator["title"] as String,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                switch (calculator["title"]) {
                  case "EMI Calculator":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EmiScreen(),
                      ),
                    );
                    break;

                  case "GST Calculator":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GstScreen(),
                      ),
                    );
                    break;

                  default:
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${calculator["title"]} coming soon",
                        ),
                      ),
                    );
                }
              },
            ),
          );
        },
      ),
    );
  }
}