import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/produto.dart';

class TopProdutosChart extends StatelessWidget {
  const TopProdutosChart({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Produto>('produtos');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<Produto> box, _) {
        final produtos = box.values.toList();

        if (produtos.isEmpty) {
          return const Center(child: Text('Sem dados de produtos'));
        }

        // 🔹 Calcula lucro total de cada produto
        final Map<String, double> lucroPorProduto = {};
        for (final p in produtos) {
          final lucro = (p.precoVenda - p.precoCusto) * p.quantidade;
          lucroPorProduto[p.nome] =
              (lucroPorProduto[p.nome] ?? 0) + lucro;
        }

// 🔹 Ordena pelo lucro decrescente e pega os 5 principais
        final sortedProdutos = lucroPorProduto.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        final topProdutos = sortedProdutos.take(5).toList();

        // 🔹 Cores para cada fatia
        final List<Color> colors = [
          const Color(0xFF1565C0),
          const Color(0xFF2E7D32),
          const Color(0xFFEF6C00),
          const Color(0xFF6A1B9A),
          const Color(0xFFD81B60),
        ];

        // 🔹 Cria as seções do PieChart
        final sections = List.generate(topProdutos.length, (index) {
          final produto = topProdutos[index];
          return PieChartSectionData(
            value: produto.value,
            // 👇 Tira o título de cima da cor
            showTitle: false, 
            radius: 60,
            color: colors[index % colors.length],
          );
        });

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.12)),
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
                const Text(
                  'Top 5 produtos lucrativos',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    // --- 1. O GRÁFICO DE PIZZA ---
                    SizedBox(
                      height: 240,
                      child: PieChart(
                        PieChartData(
                          sections: sections, // Usa a sua lista gerada lá em cima
                          centerSpaceRadius: 40,
                          sectionsSpace: 1.0, // 👇 Diminui as linhas brancas!
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24), // Espaço entre o gráfico e a legenda
                    
                    // --- 2. A LEGENDA DINÂMICA ---
                    Wrap(
                      spacing: 16, // Espaço entre um item e outro
                      runSpacing: 12, // Espaço se pular de linha
                      alignment: WrapAlignment.center,
                      // Gera uma legenda para cada produto do seu Top 5
                      children: List.generate(topProdutos.length, (index) {
                        final produto = topProdutos[index];
                        final cor = colors[index % colors.length];
                        
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: cor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              produto.key, // Nome do produto
                              style: const TextStyle(
                                fontSize: 13, 
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }),
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
