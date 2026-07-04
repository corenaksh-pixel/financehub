import 'package:flutter/material.dart';
import 'package:financehub/features/settings/presentation/widgets/profile_card.dart';
import 'package:financehub/features/settings/presentation/widgets/settings_group.dart';
import 'package:financehub/features/settings/presentation/widgets/settings_tile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:financehub/core/services/history_service.dart';
import 'package:financehub/features/settings/presentation/privacy_policy_screen.dart';
import 'package:financehub/features/settings/presentation/terms_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financehub/features/settings/providers/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() =>
      _SettingsScreenState();
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
              SwitchListTile(
                value: notifications,
                onChanged: (value) {
                  setState(() {
                    notifications = value;
                  });
                },
                secondary: const Icon(Icons.notifications),
                title: const Text("Notifications"),
              ),
              SettingsTile(
                icon: Icons.share,
                title: "Share App",
                onTap: () {
                  final box = context.findRenderObject() as RenderBox;

                  SharePlus.instance.share(
                    ShareParams(
                      text: '''
FinanceHub

Your all-in-one finance calculator.

✓ EMI Calculator
✓ SIP Calculator
✓ GST Calculator
✓ Income Tax Calculator
✓ FD / RD / PPF

Coming soon on Play Store & App Store.
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
                onTap: () {},
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
                subtitle: "support@corenaksh.com",
                onTap: () async {
                  final uri = Uri(
                    scheme: 'mailto',
                    path: 'support@corenaksh.com',
                    queryParameters: {'subject': 'FinanceHub Support'},
                  );

                  await launchUrl(uri);
                },
              ),
              SettingsTile(
                icon: Icons.info_outline,
                title: "About FinanceHub",
                onTap: () async {
                  final info = await PackageInfo.fromPlatform();

                  if (!context.mounted) return;

                  showAboutDialog(
                    context: context,
                    applicationName: "FinanceHub",
                    applicationVersion: '${info.version} (${info.buildNumber})',
                    applicationLegalese: "© 2026 CoreNaksh Technologies",
                    children: const [
                      SizedBox(height: 12),
                      Text(
                        "FinanceHub is an all-in-one finance calculator designed to help users make smarter financial decisions.",
                      ),
                    ],
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
        ],
      ),
    );
  }
}
