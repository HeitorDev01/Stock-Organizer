import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/produto.dart';
import '../utils/chart_utils.dart';

class LucroPorCategoriaChart extends StatelessWidget {
  const LucroPorCategoriaChart({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Produto>('produtos');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<Produto> box, _) {
        final produtos = box.values.toList();

        if (produtos.isEmpty) {
          return const Text('Sem dados por categoria');
        }

        /// 🔹 AGRUPA O LUCRO POR CATEGORIA
        final Map<String, double> lucroPorCategoria = {};

        for (final p in produtos) {
          final lucro =
              (p.precoVenda - p.precoCusto) * p.quantidade;

          lucroPorCategoria[p.categoria] =
              (lucroPorCategoria[p.categoria] ?? 0) + lucro;
        }

        final categorias = lucroPorCategoria.keys.toList();
        final valores = lucroPorCategoria.values.toList();

        final maxY = calcularMaxY(
          valores.reduce((a, b) => a > b ? a : b),
        );

        final List<List<Color>> gradients = [
          [const Color(0xFF1565C0), const Color(0xFF42A5F5)],


        ];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withOpacity(0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 TÍTULO DO CARD
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Lucro por categoria',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// 🔹 GRÁFICO
                SizedBox(
                  height: 240,
                  child: BarChart(
                    BarChartData(
                      maxY: maxY,
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(enabled: false),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: maxY / 5,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.15),
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          );
                        },
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
                            interval: maxY / 5,
                            reservedSize: 55,
                            getTitlesWidget: (value, _) => Text(
                              'R\$ ${value.toInt()}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              final index = value.toInt();
                              if (index < categorias.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    categorias[index],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.black87,
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
                        final lucro =
                            lucroPorCategoria[categorias[index]]!;
                        final gradient =
                            gradients[index % gradients.length];

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: lucro,
                              width: 22,
                              borderRadius: BorderRadius.circular(6),
                              gradient: LinearGradient(
                                colors: gradient,
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ],
                        );
                      }),
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
