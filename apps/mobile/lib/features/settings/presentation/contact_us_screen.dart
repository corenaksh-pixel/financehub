import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'corenaksh.tech@gmail.com',
      queryParameters: {
        'subject': 'CoreNaksh Finance Support',
      },
    );

    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
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
              "CoreNaksh Technologies",
              style: TextStyle(
                fontSize: 24,
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

          const SizedBox(height: 30),

          const ListTile(
            leading: Icon(Icons.email),
            title: Text("Support Email"),
            subtitle: Text("corenaksh.tech@gmail.com"),
          ),

          const ListTile(
            leading: Icon(Icons.location_on),
            title: Text("Country"),
            subtitle: Text("India"),
          ),

          const ListTile(
            leading: Icon(Icons.access_time),
            title: Text("Business Hours"),
            subtitle: Text("Mon – Sat | 9:00 AM – 6:00 PM IST"),
          ),

          const SizedBox(height: 30),

          FilledButton.icon(
            onPressed: _sendEmail,
            icon: const Icon(Icons.email),
            label: const Text("Send Email"),
          ),

          const SizedBox(height: 40),

          const Center(
            child: Text(
              "We usually respond within 24–48 business hours.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 20),

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