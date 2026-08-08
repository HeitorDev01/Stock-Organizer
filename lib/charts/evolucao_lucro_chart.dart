import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/produto.dart';
import '../theme/theme.dart';
import '../utils/chart_utils.dart';
import '../utils/formatters.dart';
import '../widgets/ui/chart_card.dart';
import '../widgets/ui/empty_state.dart';

/// Projeção de lucro para os próximos 6 meses.
///
/// Traço de 1.5px, sem gradiente colorido e sem grade vertical — a linha é a
/// informação, tudo o mais recua.
class EvolucaoLucroChart extends StatelessWidget {
  const EvolucaoLucroChart({super.key});

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
            title: 'Projeção de lucro',
            subtitle: 'Próximos 6 meses',
            child: EmptyState(
              icon: Icons.show_chart_outlined,
              title: 'Sem dados para projeção',
            ),
          );
        }

        /// 🔹 LUCRO TOTAL ATUAL
        final lucroAtual = produtos.fold<double>(
          0,
          (total, p) => total + ((p.precoVenda - p.precoCusto) * p.quantidade),
        );

        /// 🔹 SIMULAÇÃO DE CRESCIMENTO (6 meses)
        final List<double> projecao = List.generate(
          6,
          (index) => lucroAtual * (1 + (index * 0.15)),
        );

        final maxY = calcularMaxY(
          projecao.reduce((a, b) => a > b ? a : b),
        );

        final DateTime now = DateTime.now();

        return ChartCard(
          title: 'Projeção de lucro',
          subtitle: 'Cenário de crescimento de 15% ao mês',
          trailing: Text(
            formatCompactBRL(projecao.last),
            style: context.text.titleLarge!.copyWith(color: t.textPrimary),
          ),
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                horizontalInterval: maxY / 4,
                drawVerticalLine: false,
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
                    interval: 1,
                    reservedSize: 32,
                    getTitlesWidget: (value, _) {
                      final DateTime month = DateTime(
                        now.year,
                        now.month + value.toInt(),
                      );
                      return Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(
                          formatMonthShort(month),
                          style: context.text.bodySmall!.copyWith(
                            color: t.chartAxisLabel,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => t.surfaceInverse,
                  tooltipBorderRadius: AppRadii.control,
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  getTooltipItems: (List<LineBarSpot> spots) => spots
                      .map(
                        (LineBarSpot s) => LineTooltipItem(
                          formatBRL(s.y),
                          context.text.bodySmall!
                              .copyWith(color: t.textInverse),
                        ),
                      )
                      .toList(),
                ),
              ),
              lineBarsData: <LineChartBarData>[
                LineChartBarData(
                  spots: List.generate(
                    projecao.length,
                    (index) => FlSpot(index.toDouble(), projecao[index]),
                  ),
                  isCurved: true,
                  curveSmoothness: 0.28,
                  barWidth: AppBorders.focus,
                  color: t.chartLine,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                      radius: 3,
                      color: t.chartDotFill,
                      strokeWidth: AppBorders.focus,
                      strokeColor: t.chartLine,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: <Color>[
                        t.chartFill.withValues(alpha: 0.14),
                        t.chartFill.withValues(alpha: 0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
