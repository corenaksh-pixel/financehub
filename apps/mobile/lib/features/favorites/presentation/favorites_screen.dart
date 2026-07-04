import 'package:financehub/features/calculators/domain/calculator_catalog.dart';
import 'package:financehub/features/favorites/data/favorites_repository.dart';
import 'package:financehub/shared/widgets/calculator_card.dart';
import 'package:flutter/material.dart';
import 'package:financehub/shared/widgets/empty_state.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    FavoritesRepository.refresh.addListener(_reload);
  }

  @override
  void dispose() {
    FavoritesRepository.refresh.removeListener(_reload);
    super.dispose();
  }

  void _reload() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = CalculatorCatalog.calculators
        .where((c) => FavoritesRepository.isFavorite(c.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Favorites (${favorites.length})')),
      body: favorites.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border,
              title: 'No Favorites Yet',
              subtitle: 'Tap the ❤️ icon on any calculator to add it here.',
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final calculator = favorites[index];

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
    );
  }
}
