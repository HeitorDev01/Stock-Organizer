import 'package:flutter/material.dart';

/// Agrupamento visual dos itens na sidebar.
enum NavSection {
  geral('Geral'),
  estoque('Estoque'),
  analise('Análise');

  const NavSection(this.label);

  final String label;
}

/// Destinos do shell. A ordem aqui é a ordem na sidebar e na barra inferior.
enum AppDestination {
  painel(
    label: 'Painel',
    icon: Icons.grid_view_outlined,
    section: NavSection.geral,
    title: 'Painel',
    eyebrow: 'Visão consolidada',
  ),
  visaoGeral(
    label: 'Visão Geral',
    icon: Icons.insights_outlined,
    section: NavSection.geral,
    title: 'Visão Geral',
    eyebrow: 'Alertas e composição',
  ),
  estoque(
    label: 'Estoque',
    icon: Icons.inventory_2_outlined,
    section: NavSection.estoque,
    title: 'Estoque',
    eyebrow: 'Itens cadastrados',
  ),
  produtos(
    label: 'Produtos',
    icon: Icons.add_box_outlined,
    section: NavSection.estoque,
    title: 'Meus Produtos',
    eyebrow: 'Cadastro',
  ),
  graficos(
    label: 'Gráficos',
    icon: Icons.query_stats_outlined,
    section: NavSection.analise,
    title: 'Painel Financeiro',
    eyebrow: 'Projeções e ranking',
  ),
  configuracoes(
    label: 'Configurações',
    icon: Icons.tune_outlined,
    section: NavSection.geral,
    title: 'Configurações',
    eyebrow: 'Preferências',
  );

  const AppDestination({
    required this.label,
    required this.icon,
    required this.section,
    required this.title,
    required this.eyebrow,
  });

  /// Texto na sidebar / barra inferior.
  final String label;

  /// Sempre a variante *outline* — regra do design system.
  final IconData icon;

  final NavSection section;

  /// Título exibido no header da página.
  final String title;

  /// Linha de contexto acima do título.
  final String eyebrow;

  /// Destinos que aparecem na navegação principal.
  ///
  /// `configuracoes` fica fora: vive fixo na base da sidebar.
  static const List<AppDestination> primary = <AppDestination>[
    painel,
    visaoGeral,
    estoque,
    produtos,
    graficos,
  ];

  /// Destinos agrupados por seção, preservando a ordem de declaração.
  static Map<NavSection, List<AppDestination>> get grouped {
    final Map<NavSection, List<AppDestination>> map =
        <NavSection, List<AppDestination>>{};
    for (final AppDestination d in primary) {
      map.putIfAbsent(d.section, () => <AppDestination>[]).add(d);
    }
    return map;
  }
}
