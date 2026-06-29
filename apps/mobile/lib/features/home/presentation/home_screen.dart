import 'package:financehub/shared/widgets/calculator_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FinanceHub"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "👋 Good Evening",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Pratik",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              decoration: InputDecoration(
                hintText: "Search calculators...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "🔥 Popular Calculators",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: const [
                CalculatorCard(
                  icon: Icons.account_balance,
                  title: "EMI",
                ),
                CalculatorCard(
                  icon: Icons.receipt_long,
                  title: "GST",
                ),
                CalculatorCard(
                  icon: Icons.trending_up,
                  title: "SIP",
                ),
                CalculatorCard(
                  icon: Icons.savings,
                  title: "FD",
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "⭐ Recent Calculations",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Card(
              child: ListTile(
                leading: Icon(Icons.history),
                title: Text("No recent calculations"),
                subtitle: Text("Your calculation history will appear here"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}