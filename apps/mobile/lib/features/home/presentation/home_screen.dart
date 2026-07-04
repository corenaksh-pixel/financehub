import 'package:financehub/core/navigation/app_page_route.dart';
import 'package:financehub/features/calculators/domain/calculator_catalog.dart';
import 'package:financehub/features/favorites/data/favorites_repository.dart';
import 'package:financehub/features/history/data/history_repository.dart';
import 'package:financehub/features/home/presentation/widgets/dashboard/dashboard_header.dart';
import 'package:financehub/features/home/presentation/widgets/dashboard/finance_tip_card.dart';
import 'package:financehub/features/home/presentation/widgets/dashboard/quick_actions.dart';
import 'package:financehub/features/home/presentation/widgets/recent_calculations_widget.dart';
import 'package:financehub/features/home/providers/dashboard_provider.dart';
import 'package:financehub/features/home/widgets/category_section.dart';
import 'package:financehub/features/search/presentation/search_screen.dart';
import 'package:financehub/shared/widgets/calculator_card.dart';
import 'package:financehub/shared/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    HistoryRepository.refresh.addListener(_refreshDashboard);
    FavoritesRepository.refresh.addListener(_refreshDashboard);
  }

  @override
  void dispose() {
    HistoryRepository.refresh.removeListener(_refreshDashboard);
    FavoritesRepository.refresh.removeListener(_refreshDashboard);
    super.dispose();
  }

 void _refreshDashboard() {
  ref.read(dashboardProvider.notifier).refresh();
}

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(dashboardProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),

              const SizedBox(height: 24),

              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.push(
                    context,
                    AppPageRoute(page: const SearchScreen()),
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

              const SizedBox(height: 24),

              const QuickActions(),

              const SizedBox(height: 30),

              const Text(
                "⭐ Popular Calculators",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: CalculatorCatalog.popular.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final calculator = CalculatorCatalog.popular[index];

                  return CalculatorCard(
                    id: calculator.id,
                    icon: calculator.icon,
                    title: calculator.title,
                    subtitle: calculator.subtitle,
                    onTap: () {
                      Navigator.push(
                        context,
                        AppPageRoute(page: calculator.screen),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),

              const Text(
                "📂 Categories",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              const CategorySection(),

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
                  Expanded(
                    child: StatCard(
                      icon: Icons.calculate,
                      title: "Calculators",
                      value: stats.calculators.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.favorite,
                      title: "Favorites",
                      value: stats.favorites.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.history,
                      title: "Recent",
                      value: stats.recent.toString(),
                    ),
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

              const RecentCalculationsWidget(),

              const SizedBox(height: 30),

              const FinanceTipCard(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}