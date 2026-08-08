import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// TIPOGRAFIA
///
/// Poppins — sans geométrica de construção circular, empacotada localmente em
/// cinco pesos. Números grandes ganham `letterSpacing` negativo para fechar o
/// espaço que uma geométrica naturalmente abre; rótulos pequenos ganham
/// espacejamento positivo para não empastar em caixa alta.
/// ---------------------------------------------------------------------------
abstract final class AppTypography {
  static const String fontFamily = 'Poppins';

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  /// TextTheme completa, com todos os slots do Material 3 preenchidos.
  static TextTheme textTheme(Color primary, Color secondary) {
    return TextTheme(
      // Display — reservado para os números-herói.
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 52,
        fontWeight: semiBold,
        letterSpacing: -2.0,
        height: 1.02,
        color: primary,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 40,
        fontWeight: semiBold,
        letterSpacing: -1.4,
        height: 1.05,
        color: primary,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: semiBold,
        letterSpacing: -1.0,
        height: 1.08,
        color: primary,
      ),

      // Headline — números de card de métrica e títulos de página.
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: semiBold,
        letterSpacing: -0.8,
        height: 1.12,
        color: primary,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: semiBold,
        letterSpacing: -0.6,
        height: 1.16,
        color: primary,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: semiBold,
        letterSpacing: -0.4,
        height: 1.2,
        color: primary,
      ),

      // Title — cabeçalhos de seção e de card.
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: semiBold,
        letterSpacing: -0.2,
        height: 1.3,
        color: primary,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: medium,
        letterSpacing: -0.1,
        height: 1.35,
        color: primary,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 13.5,
        fontWeight: medium,
        letterSpacing: 0,
        height: 1.35,
        color: primary,
      ),

      // Body — texto corrido.
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.55,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 13.5,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.5,
        color: secondary,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: regular,
        letterSpacing: 0.1,
        height: 1.45,
        color: secondary,
      ),

      // Label — rótulos, botões, eyebrows.
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: medium,
        letterSpacing: 0.1,
        height: 1.3,
        color: primary,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.5,
        fontWeight: medium,
        letterSpacing: 0.2,
        height: 1.3,
        color: secondary,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 10.5,
        fontWeight: medium,
        letterSpacing: 1.1,
        height: 1.3,
        color: secondary,
      ),
    );
  }
}

/// Apelidos semânticos: o widget pede o *papel* do texto, não o slot Material.
extension AppTextRoles on TextTheme {
  /// Número principal do card-herói escuro.
  TextStyle get heroValue => displayMedium!;

  /// Número de um card de métrica do grid.
  TextStyle get metricValue => headlineLarge!;

  /// Rótulo abaixo/acima de um número.
  TextStyle get metricLabel => labelMedium!;

  /// "Eyebrow" em caixa alta que abre uma seção.
  TextStyle get eyebrow => labelSmall!;

  /// Título de uma seção da página.
  TextStyle get sectionTitle => titleLarge!;

  /// Título de um card.
  TextStyle get cardTitle => titleMedium!;

  /// Item de navegação da sidebar.
  TextStyle get navLabel => titleSmall!;

  /// Nome de um produto numa linha de lista.
  TextStyle get itemTitle => titleMedium!;

  /// Metadado de apoio (categoria, data, contagem).
  TextStyle get itemMeta => bodySmall!;

  /// Texto dentro de uma pill de status.
  TextStyle get pillLabel => labelSmall!;
}
