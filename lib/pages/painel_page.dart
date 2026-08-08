import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../charts/evolucao_lucro_chart.dart';
import '../models/produto.dart';
import '../navigation/app_destination.dart';
import '../navigation/app_shell.dart';
import '../theme/theme.dart';
import '../utils/formatters.dart';
import '../widgets/produto_tile.dart';
import '../widgets/ui/app_card.dart';
import '../widgets/ui/empty_state.dart';
import '../widgets/ui/fade_in.dart';
import '../widgets/ui/hero_metric_card.dart';
import '../widgets/ui/metric_card.dart';
import '../widgets/ui/responsive.dart';
import '../widgets/ui/section_header.dart';

/// Painel principal — a tela que a direção de layout descreve.
///
/// Ordem de leitura: grid de métricas → bloco escuro com o número principal →
/// gráfico → itens recentes.
class PainelPage extends StatelessWidget {
  const PainelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<Produto> produtoBox = Hive.box<Produto>('produtos');

    return ValueListenableBuilder<Box<Produto>>(
      valueListenable: produtoBox.listenable(),
      builder: (BuildContext context, Box<Produto> box, _) {
        final List<Produto> produtos = box.values.toList();

        if (produtos.isEmpty) {
          return EmptyState(
            icon: Icons.layers_outlined,
            title: 'Seu estoque está vazio',
            message: 'Cadastre o primeiro produto para o painel ganhar vida.',
            action: FilledButton.icon(
              onPressed: () =>
                  AppShellScope.of(context).goTo(AppDestination.produtos),
              icon: const Icon(Icons.add, size: AppIconSize.sm),
              label: const Text('Cadastrar produto'),
            ),
          );
        }

        // --- Agregações (mesmas expressões da versão anterior) ---
        final DateTime agora = DateTime.now();

        final int totalItens = produtos.fold<int>(
          0,
          (int soma, Produto p) => soma + p.quantidade,
        );

        final List<Produto> emBaixa =
            produtos.where((Produto p) => p.estoqueBaixo).toList();

        final int entradasMes = produtos
            .where((Produto p) =>
                p.dataAdicao.year == agora.year &&
                p.dataAdicao.month == agora.month)
            .length;

        final double valorEstoque = produtos.fold<double>(
          0,
          (double soma, Produto p) => soma + (p.precoCusto * p.quantidade),
        );

        final double lucroTotal = produtos.fold<double>(
          0,
          (double total, Produto p) => total + p.lucroTotalEstimado,
        );

        final int totalCategorias =
            produtos.map((Produto p) => p.categoria).toSet().length;

        final List<Produto> recentes = <Produto>[...produtos]
          ..sort((Produto a, Produto b) =>
              b.dataAdicao.compareTo(a.dataAdicao));

        return SingleChildScrollView(
          child: ContentContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // --- 1. Grid de métricas -------------------------------
                FadeIn(
                  child: MetricGrid(
                    children: <Widget>[
                      MetricCard(
                        label: 'Total de itens',
                        value: formatInt(totalItens),
                        icon: Icons.inventory_2_outlined,
                        caption: '${produtos.length} produtos distintos',
                      ),
                      MetricCard(
                        label: 'Itens em baixa',
                        value: formatInt(emBaixa.length),
                        icon: Icons.error_outline_rounded,
                        caption: emBaixa.isEmpty
                            ? 'Nenhuma reposição pendente'
                            : 'Abaixo do estoque mínimo',
                        // Único card invertido do grid: puxa o olho para o
                        // problema sem usar vermelho.
                        tone: emBaixa.isEmpty
                            ? AppCardTone.surface
                            : AppCardTone.inverse,
                        onTap: () => AppShellScope.of(context)
                            .goTo(AppDestination.estoque),
                      ),
                      MetricCard(
                        label: 'Entradas do mês',
                        value: formatInt(entradasMes),
                        icon: Icons.south_west_outlined,
                        caption: 'Cadastrados em ${formatMonthShort(agora)}',
                      ),
                      MetricCard(
                        label: 'Valor em estoque',
                        value: formatCompactBRL(valorEstoque),
                        icon: Icons.account_balance_wallet_outlined,
                        caption: 'A preço de custo',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // --- 2. Bloco escuro principal -------------------------
                FadeIn(
                  delay: AppMotion.stagger,
                  child: HeroMetricCard(
                    eyebrow: 'Lucro potencial do estoque',
                    value: formatBRL(lucroTotal),
                    caption:
                        'Resultado se todo o estoque atual for vendido pelo '
                        'preço de venda cadastrado.',
                    badge: emBaixa.isEmpty
                        ? null
                        : '${emBaixa.length} ${emBaixa.length == 1 ? "alerta" : "alertas"}',
                    stats: <HeroStat>[
                      HeroStat(
                        label: 'Produtos',
                        value: formatInt(produtos.length),
                      ),
                      HeroStat(
                        label: 'Categorias',
                        value: formatInt(totalCategorias),
                      ),
                      HeroStat(
                        label: 'Unidades',
                        value: formatInt(totalItens),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // --- 3. Gráfico ----------------------------------------
                const FadeIn(
                  delay: Duration(milliseconds: 90),
                  child: EvolucaoLucroChart(),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // --- 4. Itens recentes ---------------------------------
                FadeIn(
                  delay: const Duration(milliseconds: 135),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SectionHeader(
                        eyebrow: 'Movimentação',
                        title: 'Itens recentes',
                        trailing: TextButton(
                          onPressed: () => AppShellScope.of(context)
                              .goTo(AppDestination.estoque),
                          child: const Text('Ver tudo'),
                        ),
                      ),
                      for (final Produto p in recentes.take(5))
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: ProdutoTile(
                            produto: p,
                            dense: true,
                            mostrarMenu: false,
                            onDelete: () {},
                            onTap: () => AppShellScope.of(context)
                                .goTo(AppDestination.estoque),
                          ),
                        ),
                    ],
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
