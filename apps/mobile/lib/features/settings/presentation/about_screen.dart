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
      version = "${info.version} (${info.buildNumber})";
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
            child: const ListTile(
              leading: Icon(Icons.business),
              title: Text("Developer"),
              subtitle: Text("CoreNaksh Technologies"),
            ),
          ),

          Card(
            child: const ListTile(
              leading: Icon(Icons.email),
              title: Text("Support"),
              subtitle: Text("corenaksh.tech@gmail.com"),
            ),
          ),

          Card(
            child: const ListTile(
              leading: Icon(Icons.flag),
              title: Text("Made in"),
              subtitle: Text("India 🇮🇳"),
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

          SizedBox(height: 16),

          const Text("• Income Tax Calculator"),
          const Text("• GST Calculator"),
          const Text("• EMI Calculator"),
          const Text("• SIP Calculator"),
          const Text("• FD & RD Calculator"),
          const Text("• PPF Calculator"),
          const Text("• Loan Calculator"),
          const Text("• History & Favorites"),
          const Text("• PDF Export"),
          const Text("• Dark Mode"),

          const SizedBox(height: 40),

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