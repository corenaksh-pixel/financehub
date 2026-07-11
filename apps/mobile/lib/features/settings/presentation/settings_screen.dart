import 'package:flutter/material.dart';
import 'package:financehub/features/settings/presentation/widgets/profile_card.dart';
import 'package:financehub/features/settings/presentation/widgets/settings_group.dart';
import 'package:financehub/features/settings/presentation/widgets/settings_tile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:financehub/core/services/history_service.dart';
import 'package:financehub/features/settings/presentation/privacy_policy_screen.dart';
import 'package:financehub/features/settings/presentation/terms_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financehub/features/settings/providers/theme_provider.dart';
import 'package:financehub/features/settings/presentation/about_screen.dart';
import 'package:financehub/features/settings/presentation/contact_us_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ProfileCard(),

          const SizedBox(height: 24),

          SettingsGroup(
            title: "Appearance",
            children: [
              SettingsTile(
                icon: Icons.dark_mode,
                title: "Theme",
                subtitle: "Light • Dark • System",
                onTap: () async {
                  final mode = await showModalBottomSheet<ThemeMode>(
                    context: context,
                    builder: (_) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.phone_android),
                            title: const Text("System"),
                            onTap: () =>
                                Navigator.pop(context, ThemeMode.system),
                          ),
                          ListTile(
                            leading: const Icon(Icons.light_mode),
                            title: const Text("Light"),
                            onTap: () =>
                                Navigator.pop(context, ThemeMode.light),
                          ),
                          ListTile(
                            leading: const Icon(Icons.dark_mode),
                            title: const Text("Dark"),
                            onTap: () => Navigator.pop(context, ThemeMode.dark),
                          ),
                        ],
                      ),
                    ),
                  );

                  if (mode != null) {
                    await ref.read(themeProvider.notifier).setTheme(mode);
                  }
                },
              ),
              SettingsTile(
                icon: Icons.currency_rupee,
                title: "Currency",
                subtitle: "Indian Rupee (₹)",
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 20),

          SettingsGroup(
            title: "General",
            children: [
              SettingsTile(
                icon: Icons.share,
                title: "Share App",
                onTap: () {
                  final box = context.findRenderObject() as RenderBox;

                  SharePlus.instance.share(
                    ShareParams(
                      text: '''
CoreNaksh Finance

Smart Finance. Better Future.

✓ Income Tax Calculator
✓ GST Calculator
✓ EMI Calculator
✓ SIP Calculator
✓ FD Calculator
✓ RD Calculator
✓ PPF Calculator
✓ Loan Calculator
✓ Currency Converter

Developed by CoreNaksh Technologies.

Support:
corenaksh.tech@gmail.com
''',
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size,
                    ),
                  );
                },
              ),
              SettingsTile(
                icon: Icons.star_rate,
                title: "Rate App",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Rate App will be available after the Play Store release.",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          SettingsGroup(
            title: "Support",
            children: [
              SettingsTile(
                icon: Icons.email,
                title: "Contact Us",
                subtitle: "corenaksh.tech@gmail.com",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                  );
                },
              ),
              SettingsTile(
                icon: Icons.info_outline,
                title: "About",
                onTap: () async {
                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          SettingsGroup(
            title: "Legal",
            children: [
              SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: "Privacy Policy",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              SettingsTile(
                icon: Icons.description_outlined,
                title: "Terms & Conditions",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TermsScreen()),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          SettingsGroup(
            title: "Storage",
            children: [
              SettingsTile(
                icon: Icons.delete_outline,
                title: "Clear History",
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Clear History"),
                      content: const Text(
                        "Are you sure you want to delete all calculation history?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await HistoryService.clear();

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("History cleared")),
                    );
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 30),
          const Center(
            child: Column(
              children: [
                Text(
                  "CoreNaksh Finance",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("Version 1.0.0", style: TextStyle(color: Colors.grey)),
                SizedBox(height: 4),
                Text(
                  "© 2026 CoreNaksh Technologies",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
