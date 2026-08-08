import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Ênfase de uma pill. Num sistema monocromático, "alerta" é sinalizado por
/// inversão de superfície — não por vermelho.
enum PillTone {
  /// Contorno discreto sobre fundo claro: informação neutra.
  neutral,

  /// Preenchimento invertido: exige atenção.
  solid,

  /// Contorno sobre superfície invertida.
  onInverse,
}

/// Etiqueta compacta para status, categoria ou contagem.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.icon,
    this.tone = PillTone.neutral,
  });

  final String label;
  final IconData? icon;
  final PillTone tone;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    final (Color background, Color foreground, Color borderColor) =
        switch (tone) {
      PillTone.neutral => (t.surfaceMuted, t.textSecondary, t.border),
      PillTone.solid => (t.surfaceInverse, t.textInverse, t.surfaceInverse),
      PillTone.onInverse => (
          Colors.transparent,
          t.textInverseSecondary,
          t.borderInverse,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs + 1,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.round,
        border: Border.all(color: borderColor, width: AppBorders.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: AppIconSize.xs, color: foreground),
            const SizedBox(width: AppSpacing.xxs + 2),
          ],
          Text(
            label.toUpperCase(),
            style: context.text.pillLabel.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
