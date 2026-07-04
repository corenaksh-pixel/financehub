import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeService {
  static const _boxName = 'settings';
  static const _themeKey = 'theme_mode';

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  static Box get _box => Hive.box(_boxName);

  static ThemeMode loadTheme() {
    final value = _box.get(_themeKey, defaultValue: 'system');

    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static Future<void> saveTheme(ThemeMode mode) async {
    await _box.put(_themeKey, mode.name);
  }
}