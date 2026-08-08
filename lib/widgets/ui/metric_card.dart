import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'app_card.dart';

/// Card de métrica do grid superior.
///
/// Hierarquia forte: ícone outline discreto no topo, número grande, rótulo
/// pequeno em cinza médio. Nada compete com o número.
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.caption,
    this.tone = AppCardTone.surface,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;

  /// Linha de contexto abaixo do rótulo (ex.: "de 12 categorias").
  final String? caption;

  final AppCardTone tone;
  final VoidCallback? onTap;

  bool get _inverse => tone == AppCardTone.inverse;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = context.text;

    final Color valueColor = _inverse ? t.textInverse : t.textPrimary;
    final Color labelColor =
        _inverse ? t.textInverseSecondary : t.textSecondary;
    final Color iconColor = _inverse ? t.textInverseSecondary : t.iconSecondary;

    return AppCard(
      tone: tone,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: AppIconSize.md, color: iconColor),
          const SizedBox(height: AppSpacing.xxl),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: text.metricValue.copyWith(color: valueColor),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.metricLabel.copyWith(color: labelColor),
          ),
          if (caption != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              caption!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.bodySmall!.copyWith(
                color: _inverse ? t.textInverseSecondary : t.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
