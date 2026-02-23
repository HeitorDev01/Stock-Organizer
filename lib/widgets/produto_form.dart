import 'package:flutter/material.dart';
import '../models/produto.dart';

class ProdutoForm extends StatefulWidget {
  final Produto? produto;
  final Function(Produto) onSalvar;

  const ProdutoForm({
    super.key, 
    this.produto, 
    required this.onSalvar
  });

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
    _categoriaController = TextEditingController(text: widget.produto?.categoria ?? '');
    _custoController = TextEditingController(text: widget.produto?.precoCusto.toString() ?? '');
    _vendaController = TextEditingController(text: widget.produto?.precoVenda.toString() ?? '');
    _qtdController = TextEditingController(text: widget.produto?.quantidade.toString() ?? '');
    _minimoController = TextEditingController(text: widget.produto?.estoqueMinimo.toString() ?? '5');
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
    // Ajuste para o teclado não cobrir o botão
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Fundo BRANCO Sólido
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)), // Cantos arredondados
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent, // Mantém transparente para o efeito visual do Container
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Barrinha cinza (Handle) para indicar que pode arrastar
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // 2. Título
                  Text(
                    widget.produto == null ? 'Novo Produto' : 'Editar Produto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900], // Azul escuro para contraste
                    ),
                  ),
                  const SizedBox(height: 25),
            
                  // 3. Campos do Formulário
                  TextFormField(
                    controller: _nomeController,
                    decoration: _inputDecoration('Nome do Produto', Icons.shopping_bag_outlined),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 15),
            
                  TextFormField(
                    controller: _categoriaController,
                    decoration: _inputDecoration('Categoria', Icons.category_outlined),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 15),
            
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _custoController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: _inputDecoration('Custo (R\$)', Icons.attach_money),
                          validator: (value) => value!.isEmpty ? 'Falta o valor' : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _vendaController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: _inputDecoration('Venda (R\$)', Icons.monetization_on_outlined),
                          validator: (value) => value!.isEmpty ? 'Falta o valor' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
            
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _qtdController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration('Qtd Atual', Icons.inventory_2_outlined),
                          validator: (value) => value!.isEmpty ? 'Falta a qtd' : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _minimoController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration('Mínimo', Icons.warning_amber_rounded),
                          validator: (value) => value!.isEmpty ? 'Falta o min' : null,
                        ),
                      ),
                    ],
                  ),
            
                  const SizedBox(height: 30),
            
                  // 4. Botão Salvar Grande e Bonito
                  // 4. Botões de Ação
                  Row(
                    children: [
                      // Botão Cancelar (Cinza)
                      Expanded(
                        child: SizedBox(
                          height: 55,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: () => Navigator.pop(context), // Fecha a janela
                            child: Text(
                              'CANCELAR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 15), // Espaço entre os botões
                      
                      // Botão Salvar (Azul)
                      Expanded(
                        child: SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1565C0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 2,
                            ),
                            onPressed: _submitForm, // Chama a função de salvar
                            child: const Text(
                              'SALVAR',
                              style: TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold, 
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Estilo visual dos inputs
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
      filled: true,
      fillColor: Colors.grey[100], // Cinza bem clarinho no fundo do input
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // Remove borda preta padrão
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final custo = double.tryParse(_custoController.text.replaceAll(',', '.')) ?? 0.0;
      final venda = double.tryParse(_vendaController.text.replaceAll(',', '.')) ?? 0.0;
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