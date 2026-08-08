import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'app_card.dart';
import 'status_pill.dart';

/// Um número de apoio dentro do card-herói.
class HeroStat {
  const HeroStat({required this.label, required this.value});

  final String label;
  final String value;
}

/// Card grande escuro que ancora a tela.
///
/// É o único bloco de contraste máximo da página — por isso carrega a
/// informação principal e mais nada.
class HeroMetricCard extends StatelessWidget {
  const HeroMetricCard({
    super.key,
    required this.eyebrow,
    required this.value,
    this.caption,
    this.badge,
    this.stats = const <HeroStat>[],
    this.action,
  });

  final String eyebrow;
  final String value;
  final String? caption;

  /// Pill no canto superior direito (ex.: "12 alertas").
  final String? badge;

  /// Números secundários listados na base do card.
  final List<HeroStat> stats;

  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = context.text;
    final compact = context.isCompact;

    return AppCard(
      tone: AppCardTone.inverse,
      padding: EdgeInsets.all(compact ? AppSpacing.xl : AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  eyebrow.toUpperCase(),
                  style: text.eyebrow.copyWith(color: t.textInverseSecondary),
                ),
              ),
              if (badge != null)
                StatusPill(label: badge!, tone: PillTone.onInverse),
            ],
          ),
          SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xl),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: text.heroValue.copyWith(color: t.textInverse),
            ),
          ),
          if (caption != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(
              caption!,
              style: text.bodyMedium!.copyWith(color: t.textInverseSecondary),
            ),
          ],
          if (stats.isNotEmpty) ...<Widget>[
            SizedBox(height: compact ? AppSpacing.xl : AppSpacing.xxl),
            Container(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: t.borderInverse,
                    width: AppBorders.hairline,
                  ),
                ),
              ),
              child: Wrap(
                spacing: AppSpacing.xxxl,
                runSpacing: AppSpacing.lg,
                children: stats
                    .map((HeroStat s) => _HeroStatBlock(stat: s))
                    .toList(growable: false),
              ),
            ),
          ],
          if (action != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xl),
            action!,
          ],
        ],
      ),
    );
  }
}

class _HeroStatBlock extends StatelessWidget {
  const _HeroStatBlock({required this.stat});

  final HeroStat stat;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = context.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          stat.value,
          style: text.headlineSmall!.copyWith(color: t.textInverse),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          stat.label.toUpperCase(),
          style: text.eyebrow.copyWith(color: t.textInverseSecondary),
        ),
      ],
    );
  }
}
