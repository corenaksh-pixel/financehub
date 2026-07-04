import 'package:flutter/material.dart';
import 'theme_service.dart';

class ThemeController extends ChangeNotifier {
  ThemeController() {
    _themeMode = ThemeService.loadTheme();
  }

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> changeTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await ThemeService.saveTheme(mode);
  }
}