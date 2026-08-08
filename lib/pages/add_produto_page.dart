import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/produto.dart';
import '../theme/theme.dart';
import '../widgets/produto_form.dart';
import '../widgets/produto_tile.dart';
import '../widgets/ui/app_search_field.dart';
import '../widgets/ui/empty_state.dart';
import '../widgets/ui/fade_in.dart';
import '../widgets/ui/responsive.dart';
import '../widgets/ui/section_header.dart';

/// Cadastro e consulta rápida de produtos.
///
/// A lógica de gravação no Hive (criar vs. atualizar campo a campo) é a mesma
/// da versão anterior.
class AddProdutoPage extends StatefulWidget {
  const AddProdutoPage({super.key});

  @override
  State<AddProdutoPage> createState() => _AddProdutoPageState();
}

class _AddProdutoPageState extends State<AddProdutoPage> {
  String termoBusca = '';
  final TextEditingController _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool compact = context.isCompact;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ContentContainer(
        padding: EdgeInsets.fromLTRB(
          compact ? AppSpacing.md : AppSpacing.xxl,
          compact ? AppSpacing.md : AppSpacing.xl,
          compact ? AppSpacing.md : AppSpacing.xxl,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SectionHeader(
              eyebrow: 'Cadastro',
              title: 'Meus produtos',
              trailing: compact
                  ? null
                  : FilledButton.icon(
                      onPressed: () => _abrirFormulario(context),
                      icon: const Icon(Icons.add, size: AppIconSize.sm),
                      label: const Text('Novo produto'),
                    ),
            ),
            SizedBox(
              width: compact ? double.infinity : 380,
              child: AppSearchField(
                hintText: 'Pesquisar produto ou categoria...',
                controller: _buscaController,
                onChanged: (String value) =>
                    setState(() => termoBusca = value.toLowerCase()),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Produto>('produtos').listenable(),
                builder: (context, Box<Produto> box, _) {
                  final produtos = box.values.where((produto) {
                    return produto.nome.toLowerCase().contains(termoBusca) ||
                        produto.categoria.toLowerCase().contains(termoBusca);
                  }).toList();

                  if (produtos.isEmpty) {
                    return EmptyState(
                      icon: termoBusca.isEmpty
                          ? Icons.add_box_outlined
                          : Icons.search_off_outlined,
                      title: termoBusca.isEmpty
                          ? 'Nenhum produto cadastrado'
                          : 'Nenhum produto encontrado',
                      message: termoBusca.isEmpty
                          ? 'Use o botão abaixo para cadastrar o primeiro item.'
                          : 'Tente outro termo de busca.',
                      action: termoBusca.isEmpty
                          ? FilledButton.icon(
                              onPressed: () => _abrirFormulario(context),
                              icon: const Icon(Icons.add, size: AppIconSize.sm),
                              label: const Text('Cadastrar produto'),
                            )
                          : null,
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: AppSpacing.giant),
                    itemCount: produtos.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (context, index) {
                      final produto = produtos[index];
                      return FadeIn.staggered(
                        index: index,
                        child: ProdutoTile(
                          produto: produto,
                          mostrarMenu: false,
                          onTap: () =>
                              _abrirFormulario(context, produto: produto),
                          onDelete: () => box.delete(produto.key),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(context),
        icon: const Icon(Icons.add, size: AppIconSize.md),
        label: const Text('Novo produto'),
      ),
    );
  }

  void _abrirFormulario(BuildContext context, {Produto? produto}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: context.tokens.overlayScrim,
      builder: (ctx) => ProdutoForm(
        produto: produto,
        onSalvar: (novoProduto) {
          if (produto == null) {
            // Criando novo
            Hive.box<Produto>('produtos').add(novoProduto);
          } else {
            // Editando existente
            produto.nome = novoProduto.nome;
            produto.categoria = novoProduto.categoria;
            produto.precoCusto = novoProduto.precoCusto;
            produto.precoVenda = novoProduto.precoVenda;
            produto.quantidade = novoProduto.quantidade;
            produto.estoqueMinimo = novoProduto.estoqueMinimo;
            produto.save();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                produto == null ? 'Produto adicionado' : 'Produto atualizado',
              ),
            ),
          );
        },
      ),
    );
  }
}
