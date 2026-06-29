import 'package:flutter/material.dart';
import 'package:financehub/core/theme/app_theme.dart';
import 'package:financehub/navigation/main_navigation.dart';

class FinanceHubApp extends StatelessWidget {
  const FinanceHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinanceHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
    );
  }
}