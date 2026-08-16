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

/// Um item de legenda: o matiz da série, o nome do item e — quando faz
/// sentido — o valor que a fatia/barra representa.
class ChartLegendEntry {
  const ChartLegendEntry({
    required this.label,
    required this.color,
    this.value,
  });

  final String label;
  final Color color;

  /// Valor já formatado (`R$ 1,2 mil`, `320 un`). Opcional, mas recomendado:
  /// é o que permite ler o gráfico sem depender só da cor.
  final String? value;
}

/// Legenda de identificação das séries.
///
/// Marcador é um quadradinho preenchido: com matizes distintos, área cheia é o
/// que deixa a cor legível — o traço fino da versão monocromática era pequeno
/// demais para carregar hue.
///
/// Sempre presente quando há duas ou mais séries; o nome e o valor ao lado do
/// marcador garantem que nenhuma informação dependa exclusivamente da cor.
class ChartLegend extends StatelessWidget {
  const ChartLegend({super.key, required this.entries});

  final List<ChartLegendEntry> entries;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: entries.map((ChartLegendEntry e) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: AppSpacing.sm,
                height: AppSpacing.sm,
                decoration: BoxDecoration(
                  color: e.color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(AppSpacing.xxs),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  e.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall!.copyWith(
                    color: t.textSecondary,
                  ),
                ),
              ),
              if (e.value != null) ...<Widget>[
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  e.value!,
                  style: context.text.bodySmall!.copyWith(
                    color: t.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(growable: false),
    );
  }
}
