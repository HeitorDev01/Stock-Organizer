import 'package:flutter/material.dart';

import '../charts/evolucao_lucro_chart.dart';
import '../charts/lucro_por_categoria_chart.dart';
import '../charts/top_produto_chart.dart';
import '../theme/theme.dart';
import '../widgets/ui/fade_in.dart';
import '../widgets/ui/responsive.dart';
import '../widgets/ui/section_header.dart';

/// Painel financeiro — era `DashboardPage`.
///
/// Renomeada porque "Dashboard" agora é o Painel principal; aqui ficam só os
/// gráficos. Cada gráfico já traz sua própria moldura, então a página não
/// envolve mais nada em outro card (a versão antiga aninhava card dentro de
/// card).
class GraficosPage extends StatelessWidget {
  const GraficosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ContentContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SectionHeader(
              eyebrow: 'Análise',
              title: 'Painel financeiro',
            ),
            const FadeIn(child: EvolucaoLucroChart()),
            const SizedBox(height: AppSpacing.md),
            FadeIn(
              delay: AppMotion.stagger,
              child: const SplitRow(
                startFlex: 1,
                endFlex: 1,
                breakpoint: 900,
                start: LucroPorCategoriaChart(),
                end: TopProdutosChart(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
