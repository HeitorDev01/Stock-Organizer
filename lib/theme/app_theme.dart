import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_metrics.dart';
import 'app_tokens.dart';
import 'app_typography.dart';

/// ---------------------------------------------------------------------------
/// TEMA
///
/// Monocromático estrito: a hierarquia vem de contraste e peso, nunca de matiz.
/// Todo `ColorScheme` é derivado da mesma rampa neutra — inclusive `error`, que
/// se distingue por borda cheia + ícone, não por vermelho.
/// ---------------------------------------------------------------------------
abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light, AppTokens.light);
  static ThemeData get dark => _build(Brightness.dark, AppTokens.dark);

  static ColorScheme _scheme(Brightness brightness, AppTokens t) {
    final isLight = brightness == Brightness.light;
    return ColorScheme(
      brightness: brightness,
      primary: t.textPrimary,
      onPrimary: t.textInverse,
      primaryContainer: t.surfaceInverse,
      onPrimaryContainer: t.textInverse,
      secondary: t.textSecondary,
      onSecondary: t.textInverse,
      secondaryContainer: t.surfaceHover,
      onSecondaryContainer: t.textPrimary,
      tertiary: t.textTertiary,
      onTertiary: t.textInverse,
      tertiaryContainer: t.surfaceMuted,
      onTertiaryContainer: t.textPrimary,
      error: t.textPrimary,
      onError: t.textInverse,
      errorContainer: t.surfaceHover,
      onErrorContainer: t.textPrimary,
      surface: t.surface,
      onSurface: t.textPrimary,
      surfaceDim: isLight ? t.surfaceHover : t.canvas,
      surfaceBright: isLight ? t.surface : t.surfaceHover,
      surfaceContainerLowest: isLight ? t.surface : t.canvas,
      surfaceContainerLow: t.surfaceMuted,
      surfaceContainer: t.canvas,
      surfaceContainerHigh: t.surfaceHover,
      surfaceContainerHighest: t.surfaceHover,
      onSurfaceVariant: t.textSecondary,
      outline: t.border,
      outlineVariant: t.surfaceHover,
      shadow: const Color(0xFF000000),
      scrim: t.overlayScrim,
      inverseSurface: t.surfaceInverse,
      onInverseSurface: t.textInverse,
      inversePrimary: t.surfaceInverse,
      surfaceTint: Colors.transparent,
    );
  }

  static ThemeData _build(Brightness brightness, AppTokens t) {
    final scheme = _scheme(brightness, t);
    final text = AppTypography.textTheme(t.textPrimary, t.textSecondary);
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      extensions: <ThemeExtension<dynamic>>[t],
      fontFamily: AppTypography.fontFamily,
      textTheme: text,
      scaffoldBackgroundColor: t.canvas,
      canvasColor: t.canvas,
      dividerColor: t.border,

      // Sem tinta de elevação: superfícies não escurecem ao "subir".
      applyElevationOverlayColor: false,

      // Sem ondas de toque coloridas — o feedback é a mudança de superfície.
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: t.surfaceHover,

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        },
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: t.canvas,
        foregroundColor: t.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.none,
        scrolledUnderElevation: AppElevation.none,
        centerTitle: false,
        titleTextStyle: text.headlineSmall,
        iconTheme: IconThemeData(
          color: t.iconPrimary,
          size: AppIconSize.lg,
        ),
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ),

      cardTheme: CardThemeData(
        color: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.none,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.card,
          side: BorderSide(color: t.border, width: AppBorders.hairline),
        ),
      ),

      iconTheme: IconThemeData(color: t.iconPrimary, size: AppIconSize.md),

      dividerTheme: DividerThemeData(
        color: t.border,
        thickness: AppBorders.hairline,
        space: AppBorders.hairline,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.surface,
        hintStyle: text.bodyMedium?.copyWith(color: t.textTertiary),
        labelStyle: text.bodyMedium?.copyWith(color: t.textSecondary),
        floatingLabelStyle: text.labelMedium?.copyWith(color: t.textPrimary),
        prefixIconColor: t.iconSecondary,
        suffixIconColor: t.iconSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadii.control,
          borderSide: BorderSide(color: t.border, width: AppBorders.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.control,
          borderSide: BorderSide(color: t.border, width: AppBorders.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.control,
          borderSide: BorderSide(color: t.textPrimary, width: AppBorders.focus),
        ),
        // Erro sem vermelho: a borda vira sólida e escura, e o texto ganha peso.
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadii.control,
          borderSide: BorderSide(color: t.textPrimary, width: AppBorders.focus),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadii.control,
          borderSide: BorderSide(color: t.textPrimary, width: AppBorders.focus),
        ),
        errorStyle: text.labelMedium?.copyWith(
          color: t.textPrimary,
          fontWeight: AppTypography.semiBold,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: t.surfaceInverse,
          foregroundColor: t.textInverse,
          disabledBackgroundColor: t.surfaceHover,
          disabledForegroundColor: t.textTertiary,
          elevation: AppElevation.none,
          minimumSize: const Size(0, AppSizes.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          textStyle: text.labelLarge?.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.control),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: t.textPrimary,
          side: BorderSide(color: t.border, width: AppBorders.hairline),
          minimumSize: const Size(0, AppSizes.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          textStyle: text.labelLarge?.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.control),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: t.textSecondary,
          minimumSize: const Size(0, AppSizes.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          textStyle: text.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.control),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: t.iconPrimary,
          highlightColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.control),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: t.surfaceInverse,
        foregroundColor: t.textInverse,
        elevation: AppElevation.none,
        focusElevation: AppElevation.none,
        hoverElevation: AppElevation.none,
        highlightElevation: AppElevation.none,
        extendedTextStyle: text.labelLarge?.copyWith(
          color: t.textInverse,
          fontWeight: AppTypography.semiBold,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.nested),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: t.surfaceHover,
        elevation: AppElevation.none,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: AppRadii.control,
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: AppIconSize.md,
            color: states.contains(WidgetState.selected)
                ? t.textPrimary
                : t.iconSecondary,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => (text.labelSmall ?? const TextStyle()).copyWith(
            letterSpacing: 0.2,
            color: states.contains(WidgetState.selected)
                ? t.textPrimary
                : t.textTertiary,
          ),
        ),
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.none,
        scrimColor: t.overlayScrim,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppRadii.xl),
            bottomRight: Radius.circular(AppRadii.xl),
          ),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: t.surface,
        elevation: AppElevation.none,
        modalElevation: AppElevation.none,
        showDragHandle: true,
        dragHandleColor: t.borderStrong,
        dragHandleSize: const Size(36, 4),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.none,
        titleTextStyle: text.headlineSmall,
        contentTextStyle: text.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.card,
          side: BorderSide(color: t.border, width: AppBorders.hairline),
        ),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.overlay,
        textStyle: text.bodyMedium?.copyWith(color: t.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.nested,
          side: BorderSide(color: t.border, width: AppBorders.hairline),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: t.surfaceInverse,
        contentTextStyle: text.bodyMedium?.copyWith(color: t.textInverse),
        actionTextColor: t.textInverse,
        behavior: SnackBarBehavior.floating,
        elevation: AppElevation.none,
        insetPadding: const EdgeInsets.all(AppSpacing.xl),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.nested),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: t.surfaceInverse,
          borderRadius: AppRadii.control,
        ),
        textStyle: text.bodySmall?.copyWith(color: t.textInverse),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: t.iconSecondary,
        textColor: t.textPrimary,
        titleTextStyle: text.titleMedium,
        subtitleTextStyle: text.bodySmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.control),
      ),

      scrollbarTheme: ScrollbarThemeData(
        thickness: const WidgetStatePropertyAll<double>(6),
        radius: const Radius.circular(AppRadii.sm),
        thumbColor: WidgetStatePropertyAll<Color>(t.borderStrong),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: t.textPrimary,
        linearTrackColor: t.surfaceHover,
        circularTrackColor: t.surfaceHover,
      ),
    );
  }
}

/// Atalhos de leitura do design system a partir do contexto.
extension AppThemeContext on BuildContext {
  /// Tokens semânticos monocromáticos do tema ativo.
  AppTokens get tokens =>
      Theme.of(this).extension<AppTokens>() ?? AppTokens.light;

  /// TextTheme completa (use com os apelidos de `AppTextRoles`).
  TextTheme get text => Theme.of(this).textTheme;

  /// Largura útil da janela — base de todas as decisões responsivas.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  bool get isCompact => AppBreakpoints.isCompact(screenWidth);
  bool get isMedium => AppBreakpoints.isMedium(screenWidth);
  bool get isExpanded => AppBreakpoints.isExpanded(screenWidth);
}
