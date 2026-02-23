import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/produto.dart';
import '../utils/chart_utils.dart';

class EvolucaoLucroChart extends StatelessWidget {
  const EvolucaoLucroChart({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Produto>('produtos');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<Produto> box, _) {
        final produtos = box.values.toList();

        if (produtos.isEmpty) {
          return const Text('Sem dados para projeção');
        }

        /// 🔹 LUCRO TOTAL ATUAL
        final lucroAtual = produtos.fold<double>(
          0,
          (total, p) =>
              total + ((p.precoVenda - p.precoCusto) * p.quantidade),
        );

        /// 🔹 SIMULAÇÃO DE CRESCIMENTO (6 meses)
        final List<double> projecao = List.generate(
          6,
          (index) => lucroAtual * (1 + (index * 0.15)),
        );

        final maxY = calcularMaxY(
          projecao.reduce((a, b) => a > b ? a : b),
        );

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
                /// 🔹 TÍTULO
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Projeção de lucro',
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
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: maxY,
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: maxY / 5,
                        drawVerticalLine: false,
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
                            interval: 1,
                            getTitlesWidget: (value, _) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Mês ${value.toInt() + 1}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black87,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            projecao.length,
                            (index) => FlSpot(
                              index.toDouble(),
                              projecao[index],
                            ),
                          ),
                          isCurved: true,
                          barWidth: 3,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1565C0), Color(0xFF42A5F5)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, _, __, ___) {
                              return FlDotCirclePainter(
                                radius: 3,
                                color: Colors.white,
                                strokeWidth: 2,
                                strokeColor: const Color(0xFF1565C0),
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF1565C0).withOpacity(0.3),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
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
