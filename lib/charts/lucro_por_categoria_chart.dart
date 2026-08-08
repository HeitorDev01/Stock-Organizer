import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/produto.dart';
import '../theme/theme.dart';
import '../utils/chart_utils.dart';
import '../utils/formatters.dart';
import '../widgets/ui/chart_card.dart';
import '../widgets/ui/empty_state.dart';

/// Lucro agregado por categoria.
///
/// Barras chapadas em tons da rampa, sem gradiente: numa escala de cinza o
/// degradê destruiria a comparação entre colunas.
class LucroPorCategoriaChart extends StatelessWidget {
  const LucroPorCategoriaChart({super.key});

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
            title: 'Lucro por categoria',
            child: EmptyState(
              icon: Icons.bar_chart_outlined,
              title: 'Sem dados por categoria',
            ),
          );
        }

        /// 🔹 AGRUPA O LUCRO POR CATEGORIA
        final Map<String, double> lucroPorCategoria = {};

        for (final p in produtos) {
          final lucro = (p.precoVenda - p.precoCusto) * p.quantidade;

          lucroPorCategoria[p.categoria] =
              (lucroPorCategoria[p.categoria] ?? 0) + lucro;
        }

        final categorias = lucroPorCategoria.keys.toList();
        final valores = lucroPorCategoria.values.toList();

        final maxY = calcularMaxY(
          valores.reduce((a, b) => a > b ? a : b),
        );

        return ChartCard(
          title: 'Lucro por categoria',
          subtitle: '${categorias.length} '
              '${categorias.length == 1 ? "categoria" : "categorias"}',
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => t.surfaceInverse,
                  tooltipBorderRadius: AppRadii.control,
                  getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                    formatBRL(rod.toY),
                    context.text.bodySmall!.copyWith(color: t.textInverse),
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY / 4,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: t.chartGrid,
                  strokeWidth: AppBorders.hairline,
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: maxY / 4,
                    reservedSize: 56,
                    getTitlesWidget: (value, _) => Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: Text(
                        formatCompactBRL(value),
                        textAlign: TextAlign.right,
                        style: context.text.bodySmall!.copyWith(
                          color: t.chartAxisLabel,
                        ),
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 34,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < categorias.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: Text(
                            categorias[index],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.bodySmall!.copyWith(
                              color: t.chartAxisLabel,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(categorias.length, (index) {
                final lucro = lucroPorCategoria[categorias[index]]!;

                return BarChartGroupData(
                  x: index,
                  barRods: <BarChartRodData>[
                    BarChartRodData(
                      toY: lucro,
                      width: AppSpacing.lg,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppRadii.sm / 2),
                      ),
                      color: t.seriesAt(index),
                      // Trilho de fundo: dá referência de escala sem grade densa.
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY,
                        color: t.surfaceMuted,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
