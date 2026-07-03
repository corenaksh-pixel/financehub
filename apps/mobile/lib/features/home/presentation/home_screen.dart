import 'package:financehub/features/home/providers/dashboard_provider.dart';
import 'package:financehub/shared/widgets/calculator_card.dart';
import 'package:financehub/shared/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financehub/features/home/presentation/widgets/recent_calculations_widget.dart';
import 'package:financehub/features/calculators/domain/calculator_catalog.dart';
import 'package:financehub/features/home/widgets/category_section.dart';
import 'package:financehub/features/search/presentation/search_screen.dart';

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
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "Pratik",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
                child: IgnorePointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search calculators...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "⭐ Popular Calculators",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: CalculatorCatalog.calculators.length,
                itemBuilder: (context, index) {
                  final calculator = CalculatorCatalog.calculators[index];

                  return CalculatorCard(
                    id: calculator.id,
                    icon: calculator.icon,
                    title: calculator.title,
                    subtitle: calculator.subtitle,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => calculator.screen),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 30),

              const Text(
                "📂 Categories",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              const CategorySection(),

              const SizedBox(height: 30),

              const Text(
                "📊 Quick Overview",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  StatCard(
                    icon: Icons.calculate,
                    title: "Calculators",
                    value: CalculatorCatalog.calculators.length.toString(),
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              const RecentCalculationsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
