import 'package:flutter/material.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';

/// Extensions لسهولة إضافة زر الوضع الليلي
extension ThemeExtensions on Widget {
  /// إضافة زر الوضع الليلي إلى AppBar
  Widget withThemeToggle({
    required AppThemeMode appThemeMode,
    required ValueChanged<AppThemeMode> onThemeChanged,
    double? size,
    Color? iconColor,
    String? tooltip,
  }) {
    return Builder(
      builder: (context) {
        if (this is Scaffold) {
          final scaffold = this as Scaffold;
          final appBar = scaffold.appBar;

          if (appBar != null && appBar is AppBar) {
            final newAppBar = AppBar(
              title: appBar.title,
              backgroundColor: appBar.backgroundColor,
              elevation: appBar.elevation,
              iconTheme: appBar.iconTheme,
              actions: [
                ...(appBar.actions ?? []),
                IconButton(
                  onPressed: () {
                    onThemeChanged(appThemeMode == AppThemeMode.light
                        ? AppThemeMode.dark
                        : AppThemeMode.light);
                  },
                  icon: Icon(
                    appThemeMode == AppThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    size: size,
                    color: iconColor,
                  ),
                  tooltip: tooltip ??
                      (appThemeMode == AppThemeMode.dark
                          ? 'الوضع النهاري'
                          : 'الوضع الليلي'),
                ),
              ],
            );

            return Scaffold(
              appBar: newAppBar,
              body: scaffold.body,
              backgroundColor: scaffold.backgroundColor,
              drawer: scaffold.drawer,
              endDrawer: scaffold.endDrawer,
              floatingActionButton: scaffold.floatingActionButton,
              bottomNavigationBar: scaffold.bottomNavigationBar,
            );
          }
        }

        return this;
      },
    );
  }
}

/// Extension لـ AppBar
extension AppBarThemeExtensions on AppBar {
  /// إضافة زر الوضع الليلي إلى AppBar
  AppBar withThemeToggle({
    required AppThemeMode appThemeMode,
    required ValueChanged<AppThemeMode> onThemeChanged,
    double? size,
    Color? iconColor,
    String? tooltip,
  }) {
    return AppBar(
      title: title,
      backgroundColor: backgroundColor,
      elevation: elevation,
      iconTheme: iconTheme,
      actions: [
        ...(actions ?? []),
        IconButton(
          onPressed: () {
            onThemeChanged(appThemeMode == AppThemeMode.light
                ? AppThemeMode.dark
                : AppThemeMode.light);
          },
          icon: Icon(
            appThemeMode == AppThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
            size: size,
            color: iconColor,
          ),
          tooltip: tooltip ??
              (appThemeMode == AppThemeMode.dark
                  ? 'الوضع النهاري'
                  : 'الوضع الليلي'),
        ),
      ],
    );
  }
}
