import 'package:financehub/features/home/providers/dashboard_provider.dart';
import 'package:financehub/shared/widgets/calculator_card.dart';
import 'package:financehub/shared/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "👋 Good Evening",
                style: TextStyle(
                  fontSize: 30,
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
                "⭐ Popular Calculators",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
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
                "📊 Quick Overview",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  StatCard(
                    icon: Icons.calculate,
                    title: "Calculators",
                    value: stats.calculators.toString(),
                  ),
                  const SizedBox(width: 12),
                  StatCard(
                    icon: Icons.favorite,
                    title: "Favorites",
                    value: stats.favorites.toString(),
                  ),
                  const SizedBox(width: 12),
                  StatCard(
                    icon: Icons.history,
                    title: "Recent",
                    value: stats.recent.toString(),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "🕒 Recent Calculations",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.home),
                  ),
                  title: const Text("Home Loan EMI"),
                  subtitle: const Text("₹ 8,678 / month"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),

              const SizedBox(height: 12),

              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.directions_car),
                  ),
                  title: const Text("Car Loan EMI"),
                  subtitle: const Text("₹ 14,220 / month"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}