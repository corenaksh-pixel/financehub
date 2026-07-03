import 'package:flutter/material.dart';
import 'package:financehub/features/calculators/domain/calculator_catalog.dart';
import 'package:financehub/features/calculators/domain/calculator_info.dart';
import 'package:financehub/shared/widgets/calculator_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final List<CalculatorInfo> results = CalculatorCatalog.calculators
        .where(
          (calculator) =>
              calculator.title.toLowerCase().contains(query.toLowerCase()) ||
              calculator.subtitle.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search Calculators')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search calculators...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text(
                        'No calculators found',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      itemCount: results.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder: (context, index) {
                        final calculator = results[index];

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
          ],
        ),
      ),
    );
  }
}
