import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/produto.dart';
import '../pages/add_produto_page.dart';
import '../pages/configuracoes_page.dart';
import '../pages/estoque_page.dart';
import '../pages/graficos_page.dart';
import '../pages/painel_page.dart';
import '../pages/visao_geral_page.dart';
import '../theme/theme.dart';
import '../widgets/low_stock_sheet.dart';
import '../widgets/ui/app_header.dart';
import '../widgets/ui/app_sidebar.dart';
import 'app_destination.dart';

/// Acesso à navegação do shell a partir de qualquer página filha.
class AppShellScope extends InheritedWidget {
  const AppShellScope({
    super.key,
    required this.goTo,
    required this.searchQuery,
    required super.child,
  });

  /// Troca o destino ativo.
  final void Function(AppDestination) goTo;

  /// Termo digitado no header — a página de Estoque escuta e filtra.
  final ValueNotifier<String> searchQuery;

  static AppShellScope of(BuildContext context) {
    final AppShellScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppShellScope>();
    assert(scope != null, 'AppShellScope não encontrado acima deste widget.');
    return scope!;
  }

  static AppShellScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppShellScope>();

  @override
  bool updateShouldNotify(AppShellScope oldWidget) =>
      searchQuery != oldWidget.searchQuery;
}

/// Casca do aplicativo.
///
/// Três layouts a partir da largura:
/// - `>= 1100`: sidebar expandida
/// - `720..1100`: sidebar em modo ícone
/// - `< 720`: drawer + barra de navegação inferior
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchQuery = ValueNotifier<String>('');

  late final Box<Produto> _produtoBox;
  late final Box _settingsBox;

  AppDestination _selected = AppDestination.painel;

  @override
  void initState() {
    super.initState();
    _produtoBox = Hive.box<Produto>('produtos');
    _settingsBox = Hive.box('settings');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchQuery.dispose();
    super.dispose();
  }

  String get _userName =>
      (_settingsBox.get('userName') as String?)?.trim().isNotEmpty == true
          ? _settingsBox.get('userName') as String
          : 'Gestor';

  void _goTo(AppDestination destination) {
    if (_selected == destination) return;
    setState(() => _selected = destination);
  }

  void _onSearchSubmitted(String value) {
    _searchQuery.value = value;
    _goTo(AppDestination.estoque);
  }

  void _openAlerts() {
    final List<Produto> alertas =
        _produtoBox.values.where((Produto p) => p.estoqueBaixo).toList();
    showLowStockSheet(
      context,
      alertas,
      onVerEstoque: () => _goTo(AppDestination.estoque),
    );
  }

  Widget _pageFor(AppDestination destination) {
    return switch (destination) {
      AppDestination.painel => const PainelPage(),
      AppDestination.visaoGeral => const VisaoGeralPage(),
      AppDestination.estoque => const EstoquePage(),
      AppDestination.produtos => const AddProdutoPage(),
      AppDestination.graficos => const GraficosPage(),
      AppDestination.configuracoes => const ConfiguracoesPage(),
    };
  }

  /// Todos os destinos ficam montados para preservar rolagem e filtros ao
  /// alternar de aba.
  List<AppDestination> get _stackOrder => <AppDestination>[
        ...AppDestination.primary,
        AppDestination.configuracoes,
      ];

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final double width = MediaQuery.sizeOf(context).width;
    final bool compact = AppBreakpoints.isCompact(width);
    final bool rail = AppBreakpoints.isMedium(width);

    final Widget content = ValueListenableBuilder<Box<Produto>>(
      valueListenable: _produtoBox.listenable(),
      builder: (BuildContext context, Box<Produto> box, _) {
        final int alertCount =
            box.values.where((Produto p) => p.estoqueBaixo).length;

        return Column(
          children: <Widget>[
            AppHeader(
              userName: _userName,
              pageTitle: _selected.title,
              searchController: _searchController,
              onSearchSubmitted: _onSearchSubmitted,
              onNotifications: _openAlerts,
              onAvatarTap: () => _goTo(AppDestination.configuracoes),
              alertCount: alertCount,
              onMenu: compact
                  ? () => _scaffoldKey.currentState?.openDrawer()
                  : null,
            ),
            Expanded(
              child: IndexedStack(
                index: _stackOrder.indexOf(_selected),
                children: _stackOrder
                    .map(_pageFor)
                    .toList(growable: false),
              ),
            ),
          ],
        );
      },
    );

    return AppShellScope(
      goTo: _goTo,
      searchQuery: _searchQuery,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: t.canvas,
        drawer: compact
            ? Drawer(
                width: AppBreakpoints.sidebarExpanded,
                child: AppSidebar(
                  selected: _selected,
                  showBorder: false,
                  onSelect: (AppDestination d) {
                    _scaffoldKey.currentState?.closeDrawer();
                    _goTo(d);
                  },
                ),
              )
            : null,
        body: Row(
          children: <Widget>[
            if (!compact)
              AppSidebar(
                selected: _selected,
                collapsed: rail,
                onSelect: _goTo,
              ),
            Expanded(child: content),
          ],
        ),
        bottomNavigationBar: compact ? _buildBottomNav() : null,
      ),
    );
  }

  Widget _buildBottomNav() {
    final t = context.tokens;
    final int index = AppDestination.primary.indexOf(_selected);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: t.border, width: AppBorders.hairline),
        ),
      ),
      child: NavigationBar(
        // Configurações não está na barra: chega pelo avatar ou pelo drawer.
        selectedIndex: index < 0 ? 0 : index,
        onDestinationSelected: (int i) => _goTo(AppDestination.primary[i]),
        destinations: AppDestination.primary
            .map(
              (AppDestination d) => NavigationDestination(
                icon: Icon(d.icon),
                label: d.label,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
