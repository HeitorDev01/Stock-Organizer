import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/produto.dart';
import '../navigation/app_shell.dart';
import '../theme/theme.dart';
import '../utils/formatters.dart';
import '../widgets/produto_form.dart';
import '../widgets/produto_tile.dart';
import '../widgets/ui/app_bottom_sheet.dart';
import '../widgets/ui/app_card.dart';
import '../widgets/ui/app_search_field.dart';
import '../widgets/ui/empty_state.dart';
import '../widgets/ui/fade_in.dart';
import '../widgets/ui/responsive.dart';
import '../widgets/ui/section_header.dart';
import '../widgets/ui/status_pill.dart';

/// Lista de estoque com busca e filtro por categoria.
///
/// Regras de filtragem, exclusão e edição idênticas à versão anterior; só a
/// apresentação foi reconstruída.
class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  State<EstoquePage> createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  late Box<Produto> produtoBox;
  final TextEditingController _buscaController = TextEditingController();

  String termoBusca = '';
  String? categoriaSelecionada;

  ValueNotifier<String>? _sharedSearch;

  @override
  void initState() {
    super.initState();
    produtoBox = Hive.box<Produto>('produtos');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // A busca do header é global: quando o usuário pesquisa lá, esta tela
    // assume o termo e passa a ser o destino do resultado.
    final ValueNotifier<String>? shared = AppShellScope.maybeOf(context)?.searchQuery;
    if (shared != _sharedSearch) {
      _sharedSearch?.removeListener(_applySharedSearch);
      _sharedSearch = shared;
      _sharedSearch?.addListener(_applySharedSearch);
    }
  }

  void _applySharedSearch() {
    final String value = _sharedSearch?.value ?? '';
    if (value == termoBusca) return;
    _buscaController.text = value;
    setState(() => termoBusca = value.toLowerCase());
  }

  @override
  void dispose() {
    _sharedSearch?.removeListener(_applySharedSearch);
    _buscaController.dispose();
    super.dispose();
  }

  void abrirFormulario({Produto? produto, int? index}) {
    // Era `showDialog`; virou sheet para usar a mesma moldura do cadastro.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: context.tokens.overlayScrim,
      builder: (_) => ProdutoForm(
        produto: produto,
        onSalvar: (produtoEditado) {
          if (index != null) {
            produtoBox.putAt(index, produtoEditado);
          }
          setState(() {}); // Atualiza a UI após salvar
        },
      ),
    );
  }

  List<Produto> get produtos {
    return produtoBox.values.toList();
  }

  List<Produto> get produtosFiltrados {
    return produtos.where((produto) {
      final matchCategoria = categoriaSelecionada == null ||
          produto.categoria == categoriaSelecionada;

      final matchBusca =
          produto.nome.toLowerCase().contains(termoBusca.toLowerCase());

      return matchCategoria && matchBusca;
    }).toList();
  }

  List<String> get categorias {
    final lista = produtos.map((p) => p.categoria).toSet().toList();
    lista.sort();
    return lista;
  }

  void excluirProduto(int index) {
    produtoBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Produto> todos = produtos;

    if (todos.isEmpty) {
      return const EmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'Nenhum produto cadastrado',
        message: 'Cadastre itens na aba Produtos para vê-los aqui.',
      );
    }

    final List<Produto> filtrados = produtosFiltrados;

    final bool compact = context.isCompact;

    return ContentContainer(
      // A lista rolável já reserva a folga inferior; o container não repete.
      padding: EdgeInsets.fromLTRB(
        compact ? AppSpacing.md : AppSpacing.xxl,
        compact ? AppSpacing.md : AppSpacing.xl,
        compact ? AppSpacing.md : AppSpacing.xxl,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildToolbar(filtrados.length, todos.length),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: filtrados.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off_outlined,
                    title: 'Nada encontrado',
                    message: 'Ajuste a busca ou remova o filtro de categoria.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: AppSpacing.giant),
                    itemCount: filtrados.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (BuildContext context, int index) {
                      final Produto produto = filtrados[index];
                      final int indexReal = todos.indexOf(produto);

                      return FadeIn.staggered(
                        index: index,
                        child: ProdutoTile(
                          produto: produto,
                          onTap: () => abrirFormulario(
                            produto: produto,
                            index: indexReal,
                          ),
                          onDelete: () => excluirProduto(indexReal),
                          mostrarMenu: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(int visiveis, int total) {
    final bool compact = context.isCompact;

    final Widget busca = AppSearchField(
      hintText: 'Pesquisar produto...',
      controller: _buscaController,
      onChanged: (String value) =>
          setState(() => termoBusca = value.toLowerCase()),
    );

    final Widget filtro = SoftIconButton(
      icon: Icons.filter_list_outlined,
      tooltip: 'Filtrar por categoria',
      active: categoriaSelecionada != null,
      onPressed: _mostrarFiltroCategoria,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeader(
          eyebrow: 'Estoque',
          title: visiveis == total
              ? '$total ${total == 1 ? "item" : "itens"}'
              : '$visiveis de $total itens',
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
        ),
        if (compact) ...<Widget>[
          Row(
            children: <Widget>[
              Expanded(child: busca),
              const SizedBox(width: AppSpacing.xs),
              filtro,
            ],
          ),
        ] else
          Row(
            children: <Widget>[
              SizedBox(width: 380, child: busca),
              const SizedBox(width: AppSpacing.xs),
              filtro,
            ],
          ),
        if (categoriaSelecionada != null) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: _FiltroAtivoChip(
              label: categoriaSelecionada!,
              onClear: () => setState(() => categoriaSelecionada = null),
            ),
          ),
        ],
      ],
    );
  }

  void _mostrarFiltroCategoria() {
    showAppSheet<void>(
      context: context,
      eyebrow: 'Filtro',
      title: 'Filtrar por categoria',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (categorias.isEmpty)
            const EmptyState(
              icon: Icons.category_outlined,
              title: 'Nenhuma categoria disponível',
            )
          else ...<Widget>[
            _CategoriaOption(
              label: 'Todas as categorias',
              count: produtos.length,
              selected: categoriaSelecionada == null,
              onTap: () {
                setState(() => categoriaSelecionada = null);
                Navigator.pop(context);
              },
            ),
            for (final String cat in categorias)
              _CategoriaOption(
                label: cat,
                count: produtos.where((Produto p) => p.categoria == cat).length,
                selected: categoriaSelecionada == cat,
                onTap: () {
                  setState(() => categoriaSelecionada = cat);
                  Navigator.pop(context);
                },
              ),
          ],
        ],
      ),
    );
  }
}

/// Chip que mostra e limpa o filtro ativo.
class _FiltroAtivoChip extends StatelessWidget {
  const _FiltroAtivoChip({required this.label, required this.onClear});

  final String label;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Material(
      color: t.surfaceInverse,
      borderRadius: AppRadii.round,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onClear,
        hoverColor: t.surfaceInverseMuted,
        splashFactory: NoSplash.splashFactory,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.xs,
            AppSpacing.xs,
            AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: context.text.labelMedium!.copyWith(
                  color: t.textInverse,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.close_outlined,
                size: AppIconSize.sm,
                color: t.textInverseSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Linha de opção dentro do sheet de filtro.
class _CategoriaOption extends StatelessWidget {
  const _CategoriaOption({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: AppCard(
        tone: selected ? AppCardTone.inverse : AppCardTone.muted,
        borderRadius: AppRadii.nested,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.titleMedium!.copyWith(
                  color: selected ? t.textInverse : t.textPrimary,
                ),
              ),
            ),
            StatusPill(
              label: formatInt(count),
              tone: selected ? PillTone.onInverse : PillTone.neutral,
            ),
            if (selected) ...<Widget>[
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.check_outlined,
                size: AppIconSize.sm,
                color: t.textInverse,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
