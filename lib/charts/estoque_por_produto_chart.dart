import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/produto.dart';

class EstoquePorProdutoChart extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    final box = Hive.box<Produto>('produtos');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<Produto> box, _) {
        final produtos = box.values.toList();

        if (produtos.isEmpty) {
          return const Text('Nenhum produto para exibir');
        }

        return SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              barGroups: List.generate(produtos.length, (index) {
                final produto = produtos[index];

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: produto.quantidade.toDouble(),
                      width: 20,
                      borderRadius: BorderRadius.circular(10),
                      color: produto.estoqueBaixo
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ],
                );
              }),
              titlesData: FlTitlesData(
               leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40, // espaço lateral
                  interval: 50, // 👈 MOSTRA DE 5 EM 5 (ajuste se quiser)
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < produtos.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            produtos[index].nome,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

