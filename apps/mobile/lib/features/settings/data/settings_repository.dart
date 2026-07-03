import 'package:hive_flutter/hive_flutter.dart';

class SettingsRepository {
  static const _boxName = 'settings';

  static const _themeKey = 'theme';
  static const _currencyKey = 'currency';

  const SettingsRepository._();

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  static Box get _box => Hive.box(_boxName);

  static String get theme =>
      _box.get(_themeKey, defaultValue: 'system');

  static Future<void> setTheme(String value) async {
    await _box.put(_themeKey, value);
  }

  static String get currency =>
      _box.get(_currencyKey, defaultValue: 'INR');

  static Future<void> setCurrency(String value) async {
    await _box.put(_currencyKey, value);
  }
}