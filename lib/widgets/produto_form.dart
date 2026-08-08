import 'package:flutter/material.dart';

import '../models/produto.dart';
import '../theme/theme.dart';

/// Formulário de criação/edição de produto.
///
/// Validação, parsing e o `Produto` devolvido em `onSalvar` são exatamente os
/// de antes — mudou a moldura, o agrupamento dos campos e a decoração.
class ProdutoForm extends StatefulWidget {
  final Produto? produto;
  final Function(Produto) onSalvar;

  const ProdutoForm({super.key, this.produto, required this.onSalvar});

  @override
  State<ProdutoForm> createState() => _ProdutoFormState();
}

class _ProdutoFormState extends State<ProdutoForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  late TextEditingController _nomeController;
  late TextEditingController _categoriaController;
  late TextEditingController _custoController;
  late TextEditingController _vendaController;
  late TextEditingController _qtdController;
  late TextEditingController _minimoController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.produto?.nome ?? '');
    _categoriaController =
        TextEditingController(text: widget.produto?.categoria ?? '');
    _custoController =
        TextEditingController(text: widget.produto?.precoCusto.toString() ?? '');
    _vendaController =
        TextEditingController(text: widget.produto?.precoVenda.toString() ?? '');
    _qtdController =
        TextEditingController(text: widget.produto?.quantidade.toString() ?? '');
    _minimoController = TextEditingController(
      text: widget.produto?.estoqueMinimo.toString() ?? '5',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _categoriaController.dispose();
    _custoController.dispose();
    _vendaController.dispose();
    _qtdController.dispose();
    _minimoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = context.text;
    final bool editando = widget.produto != null;

    // Ajuste para o teclado não cobrir os botões
    final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.9;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadii.xl),
          ),
          border: Border.all(color: t.border, width: AppBorders.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Handle
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Container(
                    width: AppSpacing.xxxl,
                    height: AppSpacing.xxs,
                    decoration: BoxDecoration(
                      color: t.borderStrong,
                      borderRadius: AppRadii.round,
                    ),
                  ),
                ),

                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.lg,
                      AppSpacing.xl,
                      AppSpacing.xl,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            editando ? 'EDIÇÃO' : 'NOVO REGISTRO',
                            style: text.eyebrow.copyWith(
                              color: t.textTertiary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            editando ? 'Editar produto' : 'Novo produto',
                            style: text.headlineSmall!.copyWith(
                              color: t.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // --- Identificação ---
                          _FieldGroupLabel(label: 'Identificação'),
                          TextFormField(
                            controller: _nomeController,
                            decoration: _decoration(
                              'Nome do produto',
                              Icons.label_outline,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) =>
                                value!.isEmpty ? 'Campo obrigatório' : null,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextFormField(
                            controller: _categoriaController,
                            decoration: _decoration(
                              'Categoria',
                              Icons.category_outlined,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) =>
                                value!.isEmpty ? 'Campo obrigatório' : null,
                          ),

                          const SizedBox(height: AppSpacing.xl),

                          // --- Preços ---
                          _FieldGroupLabel(label: 'Preços'),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: _custoController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: _decoration(
                                    'Custo (R\$)',
                                    Icons.payments_outlined,
                                  ),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Falta o valor' : null,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: TextFormField(
                                  controller: _vendaController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: _decoration(
                                    'Venda (R\$)',
                                    Icons.sell_outlined,
                                  ),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Falta o valor' : null,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.xl),

                          // --- Quantidades ---
                          _FieldGroupLabel(label: 'Quantidades'),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: _qtdController,
                                  keyboardType: TextInputType.number,
                                  decoration: _decoration(
                                    'Qtd. atual',
                                    Icons.inventory_2_outlined,
                                  ),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Falta a qtd' : null,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: TextFormField(
                                  controller: _minimoController,
                                  keyboardType: TextInputType.number,
                                  decoration: _decoration(
                                    'Estoque mínimo',
                                    Icons.error_outline_rounded,
                                  ),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Falta o min' : null,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.xxl),

                          // --- Ações ---
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancelar'),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: FilledButton(
                                  onPressed: _submitForm,
                                  child: const Text('Salvar'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Decoração dos campos — herda tudo do tema; só define label e ícone.
  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: AppIconSize.md),
      filled: true,
      fillColor: context.tokens.surfaceMuted,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final custo =
          double.tryParse(_custoController.text.replaceAll(',', '.')) ?? 0.0;
      final venda =
          double.tryParse(_vendaController.text.replaceAll(',', '.')) ?? 0.0;
      final qtd = int.tryParse(_qtdController.text) ?? 0;
      final min = int.tryParse(_minimoController.text) ?? 0;

      final produtoEditado = Produto(
        nome: _nomeController.text,
        categoria: _categoriaController.text,
        precoCusto: custo,
        precoVenda: venda,
        quantidade: qtd,
        estoqueMinimo: min,
        dataAdicao: widget.produto?.dataAdicao ?? DateTime.now(),
      );

      widget.onSalvar(produtoEditado);
      Navigator.pop(context);
    }
  }
}

/// Rótulo que abre um grupo de campos.
class _FieldGroupLabel extends StatelessWidget {
  const _FieldGroupLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        label.toUpperCase(),
        style: context.text.eyebrow.copyWith(color: context.tokens.textTertiary),
      ),
    );
  }
}
