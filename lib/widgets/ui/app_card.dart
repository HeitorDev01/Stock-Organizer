import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Tom de um card. O contraste por blocos do design nasce daqui: `surface` e
/// `inverse` convivem na mesma tela.
enum AppCardTone {
  /// Card claro padrão (branco no tema claro).
  surface,

  /// Card claro rebaixado, para aninhar dentro de outro card.
  muted,

  /// Card de contraste — quase-preto no tema claro, quase-branco no escuro.
  inverse,
}

/// Superfície base de todo o app: canto arredondado, borda de 1px, elevação
/// zero. Nenhuma tela desenha um `Container` decorado à mão.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.tone = AppCardTone.surface,
    this.padding = AppSpacing.card,
    this.borderRadius = AppRadii.card,
    this.onTap,
    this.showBorder = true,
    this.width,
    this.height,
  });

  final Widget child;
  final AppCardTone tone;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final bool showBorder;
  final double? width;
  final double? height;

  Color _background(AppTokens t) => switch (tone) {
        AppCardTone.surface => t.surface,
        AppCardTone.muted => t.surfaceMuted,
        AppCardTone.inverse => t.surfaceInverse,
      };

  Color _borderColor(AppTokens t) => switch (tone) {
        AppCardTone.surface => t.border,
        AppCardTone.muted => t.border,
        AppCardTone.inverse => t.surfaceInverse,
      };

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: _background(t),
        clipBehavior: Clip.antiAlias,
        // `borderRadius` e `shape` são mutuamente exclusivos no Material:
        // a borda hairline exige `shape`, então o raio vai dentro dele.
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: showBorder
              ? BorderSide(
                  color: _borderColor(t),
                  width: AppBorders.hairline,
                )
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          // Hover discreto: só o suficiente para indicar que é clicável.
          hoverColor: tone == AppCardTone.inverse
              ? t.surfaceInverseMuted
              : t.surfaceHover,
          splashFactory: NoSplash.splashFactory,
          borderRadius: borderRadius,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
