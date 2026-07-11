import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Text(
          '''
CoreNaksh Finance Privacy Policy

CoreNaksh Finance stores your calculation history and favorites locally on your device.

We do not collect personal financial information.

No financial information is uploaded to our servers.

For support:
support@corenaksh.com

© 2026 CoreNaksh Technologies
''',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}