/// Enum pour définir les modes de thème de l'application
enum AppThemeMode {
  light,
  dark,
}

/// Extension pour ajouter des méthodes utilitaires à AppThemeMode
extension AppThemeModeExtension on AppThemeMode {
  /// Retourne le nom affiché du mode de thème
  String get displayName {
    switch (this) {
      case AppThemeMode.light:
        return 'Clair';
      case AppThemeMode.dark:
        return 'Sombre';
    }
  }

  /// Retourne l'icône correspondante au mode de thème
  String get icon {
    switch (this) {
      case AppThemeMode.light:
        return '☀️';
      case AppThemeMode.dark:
        return '🌙';
    }
  }

  /// Retourne le mode opposé
  AppThemeMode get opposite {
    switch (this) {
      case AppThemeMode.light:
        return AppThemeMode.dark;
      case AppThemeMode.dark:
        return AppThemeMode.light;
    }
  }
} 
