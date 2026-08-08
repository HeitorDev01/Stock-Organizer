import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/produto.dart';
import '../theme/theme.dart';
import '../utils/formatters.dart';
import '../widgets/ui/chart_card.dart';
import '../widgets/ui/empty_state.dart';

/// Top 5 produtos por lucro estimado.
///
/// Donut de anel fino: o miolo vazio carrega o total, então o gráfico informa
/// duas coisas sem precisar de rótulo sobre as fatias.
class TopProdutosChart extends StatelessWidget {
  const TopProdutosChart({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Produto>('produtos');
    final t = context.tokens;

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<Produto> box, _) {
        final produtos = box.values.toList();

        if (produtos.isEmpty) {
          return const ChartCard(
            title: 'Top 5 produtos lucrativos',
            child: EmptyState(
              icon: Icons.donut_large_outlined,
              title: 'Sem dados de produtos',
            ),
          );
        }

        // 🔹 Calcula lucro total de cada produto
        final Map<String, double> lucroPorProduto = {};
        for (final p in produtos) {
          final lucro = (p.precoVenda - p.precoCusto) * p.quantidade;
          lucroPorProduto[p.nome] = (lucroPorProduto[p.nome] ?? 0) + lucro;
        }

        // 🔹 Ordena pelo lucro decrescente e pega os 5 principais
        final sortedProdutos = lucroPorProduto.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        final topProdutos = sortedProdutos.take(5).toList();

        final double totalTop = topProdutos.fold<double>(
          0,
          (double sum, MapEntry<String, double> e) => sum + e.value,
        );

        final sections = List.generate(topProdutos.length, (index) {
          final produto = topProdutos[index];
          return PieChartSectionData(
            value: produto.value,
            showTitle: false,
            radius: AppSpacing.lg,
            color: t.seriesAt(index),
          );
        });

        return ChartCard(
          title: 'Top 5 produtos lucrativos',
          subtitle: 'Participação no lucro estimado',
          legend: ChartLegend(
            entries: List<ChartLegendEntry>.generate(
              topProdutos.length,
              (int i) => ChartLegendEntry(
                label: topProdutos[i].key,
                color: t.seriesAt(i),
              ),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: AppSpacing.giant - AppSpacing.xl,
                  // 2px de respiro: separa fatias de cinzas vizinhos.
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                  pieTouchData: PieTouchData(enabled: true),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'TOTAL TOP 5',
                    style: context.text.eyebrow.copyWith(
                      color: t.textTertiary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    formatCompactBRL(totalTop),
                    style: context.text.headlineSmall!.copyWith(
                      color: t.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
