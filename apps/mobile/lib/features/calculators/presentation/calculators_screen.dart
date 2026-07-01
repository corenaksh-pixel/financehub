import 'package:financehub/features/emi/presentation/emi_screen.dart';
import 'package:financehub/features/gst/presentation/gst_screen.dart';
import 'package:flutter/material.dart';
import 'package:financehub/features/sip/presentation/sip_screen.dart';
import 'package:financehub/features/fd/presentation/fd_screen.dart';
import 'package:financehub/features/rd/presentation/rd_screen.dart';

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
    {"title": "SIP Calculator", "icon": Icons.trending_up, "implemented": true},
    {"title": "FD Calculator", "icon": Icons.savings, "implemented": true},
    {"title": "RD Calculator", "icon": Icons.payments, "implemented": true},
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
      appBar: AppBar(title: const Text("Calculators")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: calculators.length,
        itemBuilder: (context, index) {
          final calculator = calculators[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(calculator["icon"] as IconData, size: 32),
              title: Text(calculator["title"] as String),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                switch (calculator["title"]) {
                  case "EMI Calculator":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EmiScreen()),
                    );
                    break;

                  case "GST Calculator":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GstScreen()),
                    );
                    break;

                  case "SIP Calculator":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SipScreen()),
                    );
                    break;

                  case "FD Calculator":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FdScreen()),
                    );
                    break;

                  case "RD Calculator":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RdScreen()),
                    );
                    break;

                  default:
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${calculator["title"]} coming soon"),
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
