import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// RAMPA MONOCROMÁTICA
///
/// Cinzas neutros puros (R=G=B) — qualquer desvio introduziria temperatura de
/// cor, que é justamente o que a direção estética exclui.
/// Só o arquivo de tema referencia estes valores; widgets usam [AppTokens].
/// ---------------------------------------------------------------------------
abstract final class _Ramp {
  static const Color ink900 = Color(0xFF0A0A0A);
  static const Color ink800 = Color(0xFF141414);
  static const Color ink700 = Color(0xFF1C1C1C);
  static const Color ink600 = Color(0xFF262626);
  static const Color ink500 = Color(0xFF333333);
  static const Color ink400 = Color(0xFF404040);

  static const Color grey600 = Color(0xFF525252);
  static const Color grey500 = Color(0xFF6B6B6B);
  static const Color grey400 = Color(0xFF8A8A8A);
  static const Color grey300 = Color(0xFFA8A8A8);
  static const Color grey200 = Color(0xFFC4C4C4);
  static const Color grey100 = Color(0xFFDCDCDC);

  static const Color paper300 = Color(0xFFE7E7E7);
  static const Color paper200 = Color(0xFFEFEFEF);
  static const Color paper100 = Color(0xFFF4F4F4);
  static const Color paper50 = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
}

/// ---------------------------------------------------------------------------
/// TOKENS SEMÂNTICOS
///
/// Ponte entre a rampa crua e o significado na interface. É isto que os widgets
/// consomem, via `context.tokens`.
/// ---------------------------------------------------------------------------
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.canvas,
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceHover,
    required this.surfaceInverse,
    required this.surfaceInverseMuted,
    required this.border,
    required this.borderStrong,
    required this.borderInverse,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textInverse,
    required this.textInverseSecondary,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconInverse,
    required this.chartSeries,
    required this.chartLine,
    required this.chartGrid,
    required this.chartAxisLabel,
    required this.chartFill,
    required this.chartDotFill,
    required this.overlayScrim,
  });

  /// Fundo da página. Nunca recebe conteúdo direto — só cards.
  final Color canvas;

  /// Card claro padrão.
  final Color surface;

  /// Card claro rebaixado — usado para criar um segundo nível sem borda extra.
  final Color surfaceMuted;

  /// Realce de hover/seleção discreto.
  final Color surfaceHover;

  /// Card de contraste (quase-preto no claro, quase-branco no escuro).
  final Color surfaceInverse;

  /// Bloco interno dentro de um card invertido.
  final Color surfaceInverseMuted;

  /// Borda hairline padrão — substitui a sombra.
  final Color border;

  /// Borda de foco/seleção.
  final Color borderStrong;

  /// Borda dentro de superfícies invertidas.
  final Color borderInverse;

  /// Números e títulos.
  final Color textPrimary;

  /// Rótulos e texto de apoio.
  final Color textSecondary;

  /// Metadados de menor importância (timestamps, placeholders).
  final Color textTertiary;

  /// Texto sobre [surfaceInverse].
  final Color textInverse;

  /// Texto secundário sobre [surfaceInverse].
  final Color textInverseSecondary;

  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconInverse;

  /// Série categórica dos gráficos, do mais forte ao mais fraco.
  final List<Color> chartSeries;

  /// Traço de gráficos de linha.
  final Color chartLine;

  /// Linha de grade — quase invisível, por design.
  final Color chartGrid;

  final Color chartAxisLabel;

  /// Área sob a curva (aplicada com gradiente até transparente).
  final Color chartFill;

  /// Miolo dos pontos da linha, para que "furem" o traço.
  final Color chartDotFill;

  final Color overlayScrim;

  // --- Tema claro -----------------------------------------------------------
  static const AppTokens light = AppTokens(
    canvas: _Ramp.paper100,
    surface: _Ramp.white,
    surfaceMuted: _Ramp.paper50,
    surfaceHover: _Ramp.paper200,
    surfaceInverse: _Ramp.ink900,
    surfaceInverseMuted: _Ramp.ink700,
    border: _Ramp.paper300,
    borderStrong: _Ramp.grey200,
    borderInverse: _Ramp.ink600,
    textPrimary: _Ramp.ink900,
    textSecondary: _Ramp.grey500,
    textTertiary: _Ramp.grey400,
    textInverse: _Ramp.white,
    textInverseSecondary: _Ramp.grey300,
    iconPrimary: _Ramp.ink800,
    iconSecondary: _Ramp.grey400,
    iconInverse: _Ramp.paper50,
    chartSeries: <Color>[
      _Ramp.ink900,
      _Ramp.ink500,
      _Ramp.grey500,
      _Ramp.grey300,
      _Ramp.grey100,
    ],
    chartLine: _Ramp.ink900,
    chartGrid: _Ramp.paper300,
    chartAxisLabel: _Ramp.grey400,
    chartFill: _Ramp.ink900,
    chartDotFill: _Ramp.white,
    overlayScrim: Color(0x660A0A0A),
  );

  // --- Tema escuro ----------------------------------------------------------
  static const AppTokens dark = AppTokens(
    canvas: _Ramp.ink900,
    surface: _Ramp.ink800,
    surfaceMuted: _Ramp.ink700,
    surfaceHover: _Ramp.ink600,
    surfaceInverse: _Ramp.paper50,
    surfaceInverseMuted: _Ramp.paper200,
    border: _Ramp.ink600,
    borderStrong: _Ramp.ink400,
    borderInverse: _Ramp.grey100,
    textPrimary: _Ramp.paper50,
    textSecondary: _Ramp.grey300,
    textTertiary: _Ramp.grey500,
    textInverse: _Ramp.ink900,
    textInverseSecondary: _Ramp.grey600,
    iconPrimary: _Ramp.paper100,
    iconSecondary: _Ramp.grey400,
    iconInverse: _Ramp.ink800,
    chartSeries: <Color>[
      _Ramp.paper50,
      _Ramp.grey200,
      _Ramp.grey400,
      _Ramp.grey600,
      _Ramp.ink500,
    ],
    chartLine: _Ramp.paper50,
    chartGrid: _Ramp.ink600,
    chartAxisLabel: _Ramp.grey400,
    chartFill: _Ramp.paper50,
    chartDotFill: _Ramp.ink800,
    overlayScrim: Color(0x99000000),
  );

  @override
  AppTokens copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceMuted,
    Color? surfaceHover,
    Color? surfaceInverse,
    Color? surfaceInverseMuted,
    Color? border,
    Color? borderStrong,
    Color? borderInverse,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textInverse,
    Color? textInverseSecondary,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? iconInverse,
    List<Color>? chartSeries,
    Color? chartLine,
    Color? chartGrid,
    Color? chartAxisLabel,
    Color? chartFill,
    Color? chartDotFill,
    Color? overlayScrim,
  }) {
    return AppTokens(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceHover: surfaceHover ?? this.surfaceHover,
      surfaceInverse: surfaceInverse ?? this.surfaceInverse,
      surfaceInverseMuted: surfaceInverseMuted ?? this.surfaceInverseMuted,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      borderInverse: borderInverse ?? this.borderInverse,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textInverse: textInverse ?? this.textInverse,
      textInverseSecondary:
          textInverseSecondary ?? this.textInverseSecondary,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      iconInverse: iconInverse ?? this.iconInverse,
      chartSeries: chartSeries ?? this.chartSeries,
      chartLine: chartLine ?? this.chartLine,
      chartGrid: chartGrid ?? this.chartGrid,
      chartAxisLabel: chartAxisLabel ?? this.chartAxisLabel,
      chartFill: chartFill ?? this.chartFill,
      chartDotFill: chartDotFill ?? this.chartDotFill,
      overlayScrim: overlayScrim ?? this.overlayScrim,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      surfaceHover: Color.lerp(surfaceHover, other.surfaceHover, t)!,
      surfaceInverse: Color.lerp(surfaceInverse, other.surfaceInverse, t)!,
      surfaceInverseMuted:
          Color.lerp(surfaceInverseMuted, other.surfaceInverseMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderInverse: Color.lerp(borderInverse, other.borderInverse, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      textInverseSecondary:
          Color.lerp(textInverseSecondary, other.textInverseSecondary, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      iconInverse: Color.lerp(iconInverse, other.iconInverse, t)!,
      chartSeries: _lerpSeries(chartSeries, other.chartSeries, t),
      chartLine: Color.lerp(chartLine, other.chartLine, t)!,
      chartGrid: Color.lerp(chartGrid, other.chartGrid, t)!,
      chartAxisLabel: Color.lerp(chartAxisLabel, other.chartAxisLabel, t)!,
      chartFill: Color.lerp(chartFill, other.chartFill, t)!,
      chartDotFill: Color.lerp(chartDotFill, other.chartDotFill, t)!,
      overlayScrim: Color.lerp(overlayScrim, other.overlayScrim, t)!,
    );
  }

  static List<Color> _lerpSeries(List<Color> a, List<Color> b, double t) {
    final length = a.length < b.length ? a.length : b.length;
    return List<Color>.generate(
      length,
      (i) => Color.lerp(a[i], b[i], t)!,
      growable: false,
    );
  }

  /// Cor da série [index], repetindo a rampa se houver mais fatias que tons.
  Color seriesAt(int index) => chartSeries[index % chartSeries.length];
}
