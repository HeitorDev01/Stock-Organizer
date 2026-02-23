import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/produto.dart';
import '../utils/chart_utils.dart';


class LucroTotalChart extends StatelessWidget {
  const LucroTotalChart({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Produto>('produtos');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<Produto> box, _) {
        final produtos = box.values.toList();

        if (produtos.isEmpty) {
          return const Text('Sem dados para lucro');
        }

        final lucroTotal = produtos.fold<double>(
          0,
          (total, p) =>
              total + ((p.precoVenda - p.precoCusto) * p.quantidade),
        );
            final maxY = calcularMaxY(lucroTotal);
        return SizedBox(
          height: 180,
          child: BarChart(
           BarChartData(
  maxY: maxY,
  alignment: BarChartAlignment.center,
  barTouchData: BarTouchData(enabled: false),
  gridData: FlGridData(
    show: true,
    drawVerticalLine: false,
    horizontalInterval: maxY / 5,
    getDrawingHorizontalLine: (value) {
      return FlLine(
        color: Colors.grey.withOpacity(0.2),
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
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (_, __) => const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Total',
            style: TextStyle(fontSize: 11),
          ),
        ),
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: maxY / 5,
        reservedSize: 55,
        getTitlesWidget: (value, _) {
          return Text(
            'R\$ ${value.toInt()}',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          );
        },
      ),
    ),
  ),
  borderData: FlBorderData(show: false),
  barGroups: [
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
          toY: lucroTotal,
          width: 28,
          borderRadius: BorderRadius.circular(6),
          gradient: const LinearGradient(
            colors:[
             Color(0xFF1565C0), Color(0xFF42A5F5)],
            
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ],
    ),
  ],
),
          ),
        );
      },
    );
  }
}
