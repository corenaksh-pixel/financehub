import 'package:flutter/material.dart';
import 'package:financehub/core/services/history_service.dart';
import 'package:financehub/features/favorites/data/favorites_repository.dart';
import 'package:financehub/features/settings/data/settings_repository.dart';
import 'package:financehub/features/settings/presentation/widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String currency = SettingsRepository.currency;
  String theme = SettingsRepository.theme;

  Future<void> _changeCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("₹ INR"),
              onTap: () => Navigator.pop(context, "INR"),
            ),
            ListTile(
              title: const Text("\$ USD"),
              onTap: () => Navigator.pop(context, "USD"),
            ),
            ListTile(
              title: const Text("€ EUR"),
              onTap: () => Navigator.pop(context, "EUR"),
            ),
            ListTile(
              title: const Text("£ GBP"),
              onTap: () => Navigator.pop(context, "GBP"),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      await SettingsRepository.setCurrency(result);

      setState(() {
        currency = result;
      });
    }
  }

  Future<void> _changeTheme() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("System"),
              onTap: () => Navigator.pop(context, "system"),
            ),
            ListTile(
              title: const Text("Light"),
              onTap: () => Navigator.pop(context, "light"),
            ),
            ListTile(
              title: const Text("Dark"),
              onTap: () => Navigator.pop(context, "dark"),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      await SettingsRepository.setTheme(result);

      setState(() {
        theme = result;
      });
    }
  }

  Future<void> _clearHistory() async {
    await HistoryService.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("History cleared")),
      );
    }
  }

  Future<void> _clearFavorites() async {
    final ids = FavoritesRepository.getAll();

    for (final id in ids) {
      await FavoritesRepository.remove(id);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favorites cleared")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Appearance",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SettingsTile(
            icon: Icons.palette,
            title: "Theme",
            subtitle: theme,
            onTap: _changeTheme,
          ),

          SettingsTile(
            icon: Icons.currency_rupee,
            title: "Currency",
            subtitle: currency,
            onTap: _changeCurrency,
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Data",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SettingsTile(
            icon: Icons.history,
            title: "Clear History",
            onTap: _clearHistory,
          ),

          SettingsTile(
            icon: Icons.star,
            title: "Clear Favorites",
            onTap: _clearFavorites,
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "About",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const ListTile(
            leading: Icon(Icons.info),
            title: Text("FinanceHub"),
            subtitle: Text("Version 1.0.0"),
          ),

          const ListTile(
            leading: Icon(Icons.business),
            title: Text("Developer"),
            subtitle: Text("CoreNaksh Technologies"),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}