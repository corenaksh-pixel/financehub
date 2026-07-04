import 'package:financehub/core/theme/app_theme.dart';
import 'package:financehub/features/settings/providers/theme_provider.dart';
import 'package:financehub/navigation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinanceHubApp extends ConsumerWidget {
  const FinanceHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinanceHub',
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const MainNavigation(),
    );
  }
}