import 'dart:async';

import 'package:flutter/material.dart';
import 'package:financehub/navigation/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      setState(() {
        opacity = 1;
      });
    });

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      body: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 900),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: color.primaryContainer,
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 60,
                    color: color.primary,
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  "CoreNaksh Finance",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Smart Finance Calculator",
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 40),

                const CircularProgressIndicator(),

                const SizedBox(height: 40),

                Text(
                  "Powered by",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 6),

                Text(
                  "CoreNaksh Technologies",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
