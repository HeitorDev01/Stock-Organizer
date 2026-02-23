import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para controlar a barra de status
import 'package:hive/hive.dart';
import '../models/produto.dart';
import '../widgets/produto_tile.dart';
import '../widgets/resumo_estoque.dart';
import '../widgets/produto_form.dart';

class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  State<EstoquePage> createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  // Cores do tema
  final primaryBlue = const Color(0xFF1565C0);
  final lightBlue = const Color(0xFF42A5F5);
  final bgColor = const Color(0xFFF5F7FA); // Fundo cinza suave

  late Box<Produto> produtoBox;
  String termoBusca = '';
  String? categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    produtoBox = Hive.box<Produto>('produtos');
  }

  void abrirFormulario({Produto? produto, int? index}) {
    showDialog(
      context: context,
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
      final matchCategoria =
          categoriaSelecionada == null || produto.categoria == categoriaSelecionada;

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
    // Configura a barra de status para ícones brancos (fundo azul)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: primaryBlue, // Fundo azul para cobrir o "notch" se puxar a tela
      body: Column(
        children: [
          // 1. CABEÇALHO PERSONALIZADO (Com botão voltar)
          _buildHeader(),

          // 2. CORPO BRANCO ARREDONDADO
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
                    if (produtos.isEmpty)
                      _buildEmptyState()
                    else
                      Expanded(
                        child: Column(
                          children: [
                            // Widgets de Resumo e Filtros (Fixos no topo da lista)
                            _buildFiltersAndSummary(),
                            
                            // Lista de Produtos
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(top: 10, bottom: 80),
                                itemCount: produtosFiltrados.length,
                                itemBuilder: (context, index) {
                                  final produto = produtosFiltrados[index];
                                  final indexReal = produtos.indexOf(produto);
                                  
                                  // Adiciona Animação de Entrada
                                  return FadeInAnimation(
                                    delay: index * 50, // Cascata rápida
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                      child: ProdutoTile(
                                        produto: produto,
                                        onTap: () => abrirFormulario(
                                          produto: produto,
                                          index: indexReal,
                                        ),
                                        onDelete: () => excluirProduto(indexReal),
                                        mostrarMenu: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widgets Auxiliares ---

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30), // Espaço para Safe Area
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryBlue, lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // Botão Voltar Estilizado
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
          ),
          const SizedBox(width: 20),
          const Text(
            'Estoque',
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

  Widget _buildFiltersAndSummary() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // --- BARRA DE PESQUISA (Seu código estilizado) ---
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: lightBlue.withOpacity(0.5), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) => setState(() => termoBusca = value.toLowerCase()),
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: 'Pesquisar produto...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                prefixIcon: Icon(Icons.search_rounded, color: primaryBlue, size: 26),
                
                // 👇 AQUI: Ícone de Filtro agora abre o Modal
                suffixIcon: GestureDetector(
                  onTap: _mostrarFiltroCategoria, // Chama a nova função
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        // Muda a cor do fundo se houver filtro ativo para dar feedback visual
                        color: categoriaSelecionada != null 
                            ? primaryBlue 
                            : lightBlue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.tune_rounded, 
                        // Muda a cor do ícone se houver filtro ativo
                        color: categoriaSelecionada != null ? Colors.white : primaryBlue, 
                        size: 20
                      ),
                    ),
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
        ),
        // Apagamos o bloco de Filtro Categoria que ficava aqui!
        
        // Indicador visual de Filtro Ativo abaixo da barra de pesquisa
        if (categoriaSelecionada != null)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              children: [
                const Text("Filtrando por: ", style: TextStyle(color: Colors.grey, fontSize: 13)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        categoriaSelecionada!,
                        style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => setState(() => categoriaSelecionada = null), // Limpa o filtro
                        child: Icon(Icons.close_rounded, color: primaryBlue, size: 16),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Nenhum produto cadastrado',
            style: TextStyle(color: Colors.grey[500], fontSize: 18),
          ),
          const SizedBox(height: 100), // Empurra um pouco pra cima
        ],
      ),
    );
  }
  // --- Novo Modal de Filtro de Categoria ---
  void _mostrarFiltroCategoria() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linha cinza de puxar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.category_rounded, color: Color(0xFF1565C0), size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Filtrar por Categoria',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              if (categorias.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Nenhuma categoria disponível.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categorias.length + 1, // +1 para a opção "Todas"
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // Opção para limpar o filtro
                        return ListTile(
                          title: const Text("Todas as Categorias", style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: categoriaSelecionada == null 
                              ? const Icon(Icons.check_circle_rounded, color: Color(0xFF1565C0)) 
                              : null,
                          onTap: () {
                            setState(() => categoriaSelecionada = null);
                            Navigator.pop(context);
                          },
                        );
                      }
                      
                      final cat = categorias[index - 1];
                      final isSelected = categoriaSelecionada == cat;
                      
                      return ListTile(
                        title: Text(cat),
                        trailing: isSelected 
                            ? const Icon(Icons.check_circle_rounded, color: Color(0xFF1565C0)) 
                            : null,
                        onTap: () {
                          setState(() => categoriaSelecionada = cat);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// Widget de Animação (Para não quebrar caso não tenha importado)
class FadeInAnimation extends StatelessWidget {
  final int delay;
  final Widget child;

  const FadeInAnimation({super.key, required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: FutureBuilder(
        future: Future.delayed(Duration(milliseconds: delay)),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? child
              : const SizedBox.shrink();
        },
      ),
    );
  }
}