import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../charts/distribuicao_quantidade_chart.dart';
import '../charts/lucro_por_categoria_chart.dart';
import '../models/produto.dart';
import '../navigation/app_destination.dart';
import '../navigation/app_shell.dart';
import '../theme/theme.dart';
import '../utils/formatters.dart';
import '../widgets/low_stock_sheet.dart';
import '../widgets/ui/app_card.dart';
import '../widgets/ui/empty_state.dart';
import '../widgets/ui/fade_in.dart';
import '../widgets/ui/hero_metric_card.dart';
import '../widgets/ui/metric_card.dart';
import '../widgets/ui/responsive.dart';
import '../widgets/ui/section_header.dart';

/// Visão Geral: composição do estoque e alertas de reposição.
///
/// Mesmos indicadores de antes (produtos, categorias, lucro, estoque baixo),
/// reorganizados em blocos de contraste.
class VisaoGeralPage extends StatefulWidget {
  const VisaoGeralPage({super.key});

  @override
  State<VisaoGeralPage> createState() => _VisaoGeralPageState();
}

class _VisaoGeralPageState extends State<VisaoGeralPage> {
  late Box<Produto> produtoBox;

  @override
  void initState() {
    super.initState();
    produtoBox = Hive.box<Produto>('produtos');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: produtoBox.listenable(),
      builder: (context, Box<Produto> box, _) {
        final produtos = box.values.toList();

        final totalProdutos = produtos.length;
        final estoqueBaixo = produtos.where((p) => p.estoqueBaixo).toList();
        final totalCategorias = produtos.map((p) => p.categoria).toSet().length;

        final lucroTotal = produtos.fold<double>(
          0,
          (total, p) => total + p.lucroTotalEstimado,
        );

        if (produtos.isEmpty) {
          return const EmptyState(
            icon: Icons.insights_outlined,
            title: 'Sem dados para exibir',
            message: 'Os indicadores aparecem assim que houver produtos.',
          );
        }

        final int totalUnidades = produtos.fold<int>(
          0,
          (int soma, Produto p) => soma + p.quantidade,
        );

        return SingleChildScrollView(
          child: ContentContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // --- Bloco escuro: o número que importa -----------------
                FadeIn(
                  child: HeroMetricCard(
                    eyebrow: 'Lucro potencial',
                    value: formatBRL(lucroTotal),
                    caption: 'Somatório do lucro unitário × quantidade.',
                    badge: estoqueBaixo.isEmpty
                        ? null
                        : '${estoqueBaixo.length} para repor',
                    stats: <HeroStat>[
                      HeroStat(
                        label: 'Unidades',
                        value: formatInt(totalUnidades),
                      ),
                      HeroStat(
                        label: 'Ticket médio',
                        value: formatCompactBRL(
                          totalProdutos == 0 ? 0 : lucroTotal / totalProdutos,
                        ),
                      ),
                    ],
                    action: estoqueBaixo.isEmpty
                        ? null
                        : OutlinedButton.icon(
                            onPressed: () => showLowStockSheet(
                              context,
                              estoqueBaixo,
                              onVerEstoque: () => AppShellScope.of(context)
                                  .goTo(AppDestination.estoque),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: context.tokens.textInverse,
                              side: BorderSide(
                                color: context.tokens.borderInverse,
                                width: AppBorders.hairline,
                              ),
                            ),
                            icon: const Icon(
                              Icons.notifications_none_outlined,
                              size: AppIconSize.sm,
                            ),
                            label: const Text('Ver alertas'),
                          ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // --- Métricas ------------------------------------------
                FadeIn(
                  delay: AppMotion.stagger,
                  child: MetricGrid(
                    maxColumns: 3,
                    children: <Widget>[
                      MetricCard(
                        label: 'Produtos',
                        value: formatInt(totalProdutos),
                        icon: Icons.inventory_2_outlined,
                      ),
                      MetricCard(
                        label: 'Categorias',
                        value: formatInt(totalCategorias),
                        icon: Icons.category_outlined,
                      ),
                      MetricCard(
                        label: 'Em baixa',
                        value: formatInt(estoqueBaixo.length),
                        icon: Icons.error_outline_rounded,
                        tone: estoqueBaixo.isEmpty
                            ? AppCardTone.surface
                            : AppCardTone.inverse,
                        onTap: () => showLowStockSheet(
                          context,
                          estoqueBaixo,
                          onVerEstoque: () => AppShellScope.of(context)
                              .goTo(AppDestination.estoque),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // --- Análise -------------------------------------------
                const SectionHeader(
                  eyebrow: 'Composição',
                  title: 'Análise de estoque',
                ),
                FadeIn(
                  delay: const Duration(milliseconds: 90),
                  child: SplitRow(
                    startFlex: 1,
                    endFlex: 1,
                    breakpoint: 900,
                    start: DistribuicaoQuantidadeChart(produtos: produtos),
                    end: const LucroPorCategoriaChart(),
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
