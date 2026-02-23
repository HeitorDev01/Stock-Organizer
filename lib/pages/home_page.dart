import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../widgets/produto_form.dart';
import '../widgets/produto_tile.dart';
import '../widgets/resumo_estoque.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {
  String termoBusca = '';
  String? categoriaSelecionada;
  late Box settingsBox;
  late Box <Produto> produtoBox;
  

 List<Produto> get produtosFiltrados {
  return produtos.where((produto) {
    final matchCategoria =
        categoriaSelecionada == null ||
        produto.categoria == categoriaSelecionada;

    final matchBusca = produto.nome
        .toLowerCase()
        .contains(termoBusca.toLowerCase());

    return matchCategoria && matchBusca;
  }).toList();
}

  List<String> get categorias {
  final lista = produtos.map((p) => p.categoria).toSet().toList();
  lista.sort();
  return lista;
  
}
  List<Produto> get produtos {
    return produtoBox.values.toList();
  }

  void abrirFormulario({Produto? produto, int? index}) {
    showDialog(
      context: context,
      builder: (_) => ProdutoForm(
        produto: produto,
        onSalvar: (novoProduto) {
            if (produto == null) {
              produtoBox.add(novoProduto);
            } else {
              produtoBox.putAt(index!, novoProduto);
            }
          
        },
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Stock Organize')),
    body: produtos.isEmpty
        ? const Center(child: Text('Nenhum produto cadastrado'))
        : Column(
            children: [
              ResumoEstoque(produtos: produtos),
              // AQUI FICA O FILTRO (DROPDOWN)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:DropdownButtonFormField<String>(
                initialValue: categoriaSelecionada,
                hint: const Text('Filtrar por Categoria'),
                items: categorias
                    .map(
                      (cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                      categoriaSelecionada = value;
                    }
                  );
                  settingsBox.put('categoriaSelecionada', value);
                },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                )
              ),
              //  LISTA DE PRODUTOS
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: produtoBox.listenable(),
                  builder: (context, Box<Produto> box, _) {
                    if (box.values.isEmpty) {
                      return const Center(
                        child: Text('Nenhum produto cadastrado'),
                      );
                    }

                    final produtos = box.values.toList();

                    final produtosFiltrados = produtos.where((produto) {
                      final matchCategoria =
                          categoriaSelecionada == null ||
                          produto.categoria == categoriaSelecionada;

                      final matchBusca = produto.nome
                          .toLowerCase()
                          .contains(termoBusca.toLowerCase());

                      return matchCategoria && matchBusca;
                    }).toList();

                    return ListView.builder(
                      itemCount: produtosFiltrados.length,
                      itemBuilder: (context, index) {
                        final produto = produtosFiltrados[index];
                        final indexReal = produtos.indexOf(produto);

                        return ProdutoTile(
                          produto: produto,
                          onTap: () {
                            abrirFormulario(
                              produto: produto,
                              index: indexReal,
                            );
                          },
                          onDelete: () {
                            produtoBox.deleteAt(indexReal);
                          },
                        );
                      },
                    );
                  },
                ),
              ),

            ],
          ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => abrirFormulario(),
      child: const Icon(Icons.add),
    ),
  );
}
  @override
    void initState() {
      super.initState();

      settingsBox = Hive.box('settings');

      produtoBox = Hive.box<Produto>('produtos');

      categoriaSelecionada = settingsBox.get('categoriaSelecionada');

    }

}
