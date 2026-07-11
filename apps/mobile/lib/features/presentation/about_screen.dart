import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String version = "1.0.0";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();

    setState(() {
      version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Image.asset(
              "assets/branding/app_icon.png",
              width: 100,
              height: 100,
            ),
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              "CoreNaksh Finance",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Center(
            child: Text(
              "Smart Finance. Better Future.",
              style: TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 24),

          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Version"),
              trailing: Text(version),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.business),
              title: const Text("Developer"),
              subtitle: const Text("CoreNaksh Technologies"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.flag),
              title: const Text("Made in"),
              subtitle: const Text("India 🇮🇳"),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Features",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          const ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text("20+ Financial Calculators"),
          ),

          const ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text("Income Tax & GST"),
          ),

          const ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text("EMI, SIP & Loan Calculators"),
          ),

          const ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text("History & Favorites"),
          ),

          const ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text("PDF Export & Sharing"),
          ),

          const SizedBox(height: 30),

          const Center(
            child: Text(
              "© 2026 CoreNaksh Technologies",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}