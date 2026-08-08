import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/produto.dart';
import '../theme/theme.dart';
import '../utils/formatters.dart';
import '../widgets/ui/chart_card.dart';
import '../widgets/ui/empty_state.dart';

/// Distribuição do estoque por quantidade (5 primeiros produtos).
///
/// Extraído do corpo de `VisaoGeralPage`, onde vivia como método privado — o
/// cálculo é o mesmo, agora reutilizável e com a moldura padrão.
class DistribuicaoQuantidadeChart extends StatelessWidget {
  const DistribuicaoQuantidadeChart({super.key, required this.produtos});

  final List<Produto> produtos;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    if (produtos.isEmpty) {
      return const ChartCard(
        title: 'Distribuição por quantidade',
        child: EmptyState(
          icon: Icons.donut_large_outlined,
          title: 'Sem dados',
        ),
      );
    }

    final List<Produto> top = produtos.take(5).toList();
    final int totalUnidades = top.fold<int>(
      0,
      (int sum, Produto p) => sum + p.quantidade,
    );

    return ChartCard(
      title: 'Distribuição por quantidade',
      subtitle: 'Cinco primeiros itens do estoque',
      legend: ChartLegend(
        entries: List<ChartLegendEntry>.generate(
          top.length,
          (int i) => ChartLegendEntry(
            label: top[i].nome,
            color: t.seriesAt(i),
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: AppSpacing.giant - AppSpacing.xl,
              borderData: FlBorderData(show: false),
              sections: List<PieChartSectionData>.generate(top.length, (int i) {
                return PieChartSectionData(
                  color: t.seriesAt(i),
                  value: top[i].quantidade.toDouble(),
                  showTitle: false,
                  radius: AppSpacing.lg,
                );
              }),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'UNIDADES',
                style: context.text.eyebrow.copyWith(color: t.textTertiary),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                formatInt(totalUnidades),
                style: context.text.headlineSmall!.copyWith(
                  color: t.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
