enum AppThemeMode {
  system,
  light,
  dark,
}

extension AppThemeModeExtension on AppThemeMode {
  String get title {
    switch (this) {
      case AppThemeMode.system:
        return 'System';

      case AppThemeMode.light:
        return 'Light';

      case AppThemeMode.dark:
        return 'Dark';
    }
  }
}