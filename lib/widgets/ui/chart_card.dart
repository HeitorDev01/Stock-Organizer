import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'app_card.dart';

/// Moldura padrão de um gráfico: título, legenda opcional, e o gráfico com
/// altura fixa por breakpoint.
///
/// Todo gráfico do app entra por aqui, para que a moldura nunca divirja.
class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
    this.legend,
    this.height,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;

  /// Legenda renderizada abaixo do gráfico (use [ChartLegend]).
  final Widget? legend;

  final double? height;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = context.text;

    final double chartHeight = height ??
        (context.isCompact
            ? AppSizes.chartHeightCompact
            : AppSizes.chartHeight);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      title,
                      style: text.cardTitle.copyWith(color: t.textPrimary),
                    ),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle!,
                        style: text.bodySmall!.copyWith(color: t.textTertiary),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(height: chartHeight, child: child),
          if (legend != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            legend!,
          ],
        ],
      ),
    );
  }
}

/// Um item de legenda.
class ChartLegendEntry {
  const ChartLegendEntry({required this.label, required this.color});

  final String label;
  final Color color;
}

/// Legenda horizontal que quebra em várias linhas.
///
/// Marcador é um traço, não uma bolinha: lê melhor numa escala de cinza, onde
/// tons próximos precisam de mais área para se distinguir.
class ChartLegend extends StatelessWidget {
  const ChartLegend({super.key, required this.entries});

  final List<ChartLegendEntry> entries;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.xs,
      children: entries.map((ChartLegendEntry e) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: AppSpacing.md,
              height: AppSpacing.xxs,
              decoration: BoxDecoration(
                color: e.color,
                borderRadius: AppRadii.round,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Text(
                e.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodySmall!.copyWith(
                  color: t.textSecondary,
                ),
              ),
            ),
          ],
        );
      }).toList(growable: false),
    );
  }
}
