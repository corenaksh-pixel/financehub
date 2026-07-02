import 'package:financehub/app/app.dart';
import 'package:financehub/features/history/data/history_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HistoryRepository.init();

  runApp(
    const ProviderScope(
      child: FinanceHubApp(),
    ),
  );
}