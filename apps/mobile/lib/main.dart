import 'package:financehub/app/app.dart';
import 'package:financehub/features/favorites/data/favorites_repository.dart';
import 'package:financehub/features/history/data/history_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financehub/features/settings/data/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HistoryRepository.init();
  await FavoritesRepository.init();
  await HistoryRepository.init();
  await FavoritesRepository.init();
  await SettingsRepository.init();

  runApp(const ProviderScope(child: FinanceHubApp()));
}
