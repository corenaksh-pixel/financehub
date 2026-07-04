import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();

  int page = 0;

  final pages = [
    (
      Icons.calculate,
      "All Finance Calculators",
      "EMI, SIP, GST, FD, RD, PPF and many more."
    ),
    (
      Icons.picture_as_pdf,
      "Export Reports",
      "Generate professional PDF reports and share them."
    ),
    (
      Icons.favorite,
      "Favorites & History",
      "Quickly access your recent and favorite calculators."
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: controller,
        itemCount: pages.length,
        onPageChanged: (i) => setState(() => page = i),
        itemBuilder: (_, index) {
          final item = pages[index];

          return Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.$1,
                  size: 120,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 40),
                Text(
                  item.$2,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  item.$3,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: FilledButton(
          onPressed: () {
            if (page == pages.length - 1) {
              Navigator.pop(context);
            } else {
              controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Text(
            page == pages.length - 1 ? "Get Started" : "Next",
          ),
        ),
      ),
    );
  }
}