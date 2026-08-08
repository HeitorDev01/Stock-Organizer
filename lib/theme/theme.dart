import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

export 'app_metrics.dart';
export 'app_theme.dart';
export 'app_tokens.dart';
export 'app_typography.dart';

/// Ponto único de entrada do design system.
///
/// Qualquer arquivo de UI precisa apenas de:
/// ```dart
/// import '../theme/theme.dart';
/// ```

/// Guarda a preferência de tema (claro/escuro/sistema) na box `settings`.
///
/// É preferência de apresentação, não regra de negócio: não toca em `produtos`.
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController(this._box) : super(_read(_box));

  static const String _key = 'themeMode';

  final Box _box;

  static ThemeMode _read(Box box) {
    return switch (box.get(_key) as String?) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  void set(ThemeMode mode) {
    if (mode == value) return;
    value = mode;
    _box.put(_key, mode.name);
  }
}

/// Expõe o [ThemeController] para qualquer tela que precise trocar o tema.
class AppThemeScope extends InheritedWidget {
  const AppThemeScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final ThemeController controller;

  static ThemeController of(BuildContext context) {
    final AppThemeScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
    assert(scope != null, 'AppThemeScope não encontrado acima deste widget.');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(AppThemeScope oldWidget) =>
      controller != oldWidget.controller;
}
