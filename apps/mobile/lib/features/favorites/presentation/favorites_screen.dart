import 'package:financehub/features/calculators/domain/calculator_catalog.dart';
import 'package:financehub/features/favorites/data/favorites_repository.dart';
import 'package:financehub/shared/widgets/calculator_card.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favorites = CalculatorCatalog.calculators
        .where((c) => FavoritesRepository.isFavorite(c.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'No favorite calculators yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: favorites.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
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
                        MaterialPageRoute(
                          builder: (_) => calculator.screen,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}