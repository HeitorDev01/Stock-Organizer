import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/produto.dart';
import '../widgets/produto_tile.dart';
import '../widgets/produto_form.dart';

class AddProdutoPage extends StatefulWidget {
  const AddProdutoPage({super.key});

  @override
  State<AddProdutoPage> createState() => _AddProdutoPageState();
}

class _AddProdutoPageState extends State<AddProdutoPage> {
  String termoBusca = '';

  // Cores do Tema
  final primaryBlue = const Color(0xFF1565C0);
  final lightBlue = const Color(0xFF42A5F5);
  final bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: primaryBlue,
      body: Column(
        children: [
          // 1. CABEÇALHO
          _buildHeader(),

          // 2. CONTEÚDO BRANCO
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Column(
                  children: [
                    // A Barra de Busca
                    _buildSearchBar(),

                    // Lista de Produtos
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: Hive.box<Produto>('produtos').listenable(),
                        builder: (context, Box<Produto> box, _) {
                          final produtos = box.values.where((produto) {
                            return produto.nome.toLowerCase().contains(termoBusca) ||
                                   produto.categoria.toLowerCase().contains(termoBusca);
                          }).toList();

                          if (produtos.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off_rounded, size: 60, color: Colors.grey[300]),
                                  const SizedBox(height: 10),
                                  Text(
                                    termoBusca.isEmpty 
                                      ? 'Nenhum produto cadastrado' 
                                      : 'Nenhum produto encontrado',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            itemCount: produtos.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final produto = produtos[index];
                              return ProdutoTile(
                                produto: produto,
                                mostrarMenu: false,
                                // Ao clicar no card, abre edição
                                onTap: null,
                                onDelete: () => box.delete(produto.key),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ➕ BOTÃO FLUTUANTE
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
          onPressed: () => _abrirFormulario(context),
        ),
      ),
    );
  }
  // 👇 MATERIAL E SCROLL 

 void _abrirFormulario(BuildContext context, {Produto? produto}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, 
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

          // REMOVI O Navigator.pop DAQUI
          // O próprio ProdutoForm já fecha a janela agora.

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(produto == null 
                ? 'Produto adicionado!' 
                : 'Produto atualizado!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryBlue, lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          if (Navigator.canPop(context))
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              ),
            )
          else
             Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.list_alt_rounded, color: Colors.white, size: 20),
              ),
          const SizedBox(width: 20),
          const Text(
            'Meus Produtos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: lightBlue, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {
              termoBusca = value.toLowerCase();
            });
          },
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'Pesquisar produto...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
            prefixIcon: Icon(Icons.search_rounded, color: primaryBlue, size: 26),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                  color: lightBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ),
    );
  }
}