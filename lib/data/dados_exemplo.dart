/// Catálogo de demonstração — um mercado pequeno plausível.
///
/// Existe para que a primeira abertura do app não seja uma tela vazia: os
/// gráficos, os alertas de reposição e as métricas já aparecem preenchidos.
/// Os números foram escolhidos para exercitar o app inteiro — seis categorias
/// (uma por matiz da paleta), margens diferentes entre si e três itens abaixo
/// do estoque mínimo, para o painel de alertas ter o que mostrar.
library;

import 'package:hive/hive.dart';

import '../models/produto.dart';

const String _seedKey = 'demoSeeded';

/// Monta a lista do zero a cada chamada: são [HiveObject]s, e um mesmo objeto
/// não pode ser gravado em duas boxes/posições.
List<Produto> produtosExemplo() {
  final DateTime hoje = DateTime.now();
  DateTime diasAtras(int d) => hoje.subtract(Duration(days: d));

  return <Produto>[
    Produto(
      nome: 'Arroz branco 5kg',
      categoria: 'Mercearia',
      precoCusto: 18.90,
      precoVenda: 27.90,
      quantidade: 140,
      estoqueMinimo: 40,
      dataAdicao: diasAtras(38),
    ),
    Produto(
      nome: 'Feijão preto 1kg',
      categoria: 'Mercearia',
      precoCusto: 6.40,
      precoVenda: 9.90,
      quantidade: 95,
      estoqueMinimo: 30,
      dataAdicao: diasAtras(35),
    ),
    Produto(
      nome: 'Café torrado 500g',
      categoria: 'Mercearia',
      precoCusto: 12.20,
      precoVenda: 19.50,
      quantidade: 60,
      estoqueMinimo: 25,
      dataAdicao: diasAtras(31),
    ),
    Produto(
      nome: 'Leite integral 1L',
      categoria: 'Laticínios',
      precoCusto: 3.80,
      precoVenda: 5.49,
      quantidade: 220,
      estoqueMinimo: 80,
      dataAdicao: diasAtras(27),
    ),
    Produto(
      nome: 'Queijo mussarela kg',
      categoria: 'Laticínios',
      precoCusto: 32.00,
      precoVenda: 46.90,
      quantidade: 24,
      estoqueMinimo: 15,
      dataAdicao: diasAtras(24),
    ),
    Produto(
      nome: 'Refrigerante 2L',
      categoria: 'Bebidas',
      precoCusto: 5.20,
      precoVenda: 8.99,
      quantidade: 180,
      estoqueMinimo: 60,
      dataAdicao: diasAtras(20),
    ),
    Produto(
      nome: 'Cerveja lata 350ml',
      categoria: 'Bebidas',
      precoCusto: 2.65,
      precoVenda: 4.49,
      quantidade: 480,
      estoqueMinimo: 150,
      dataAdicao: diasAtras(17),
    ),
    Produto(
      nome: 'Detergente 500ml',
      categoria: 'Limpeza',
      precoCusto: 1.85,
      precoVenda: 3.29,
      quantidade: 150,
      estoqueMinimo: 50,
      dataAdicao: diasAtras(14),
    ),
    // Abaixo do mínimo — alimenta o alerta de reposição.
    Produto(
      nome: 'Sabão em pó 1kg',
      categoria: 'Limpeza',
      precoCusto: 9.40,
      precoVenda: 14.90,
      quantidade: 38,
      estoqueMinimo: 40,
      dataAdicao: diasAtras(11),
    ),
    // Abaixo do mínimo.
    Produto(
      nome: 'Papel higiênico 12un',
      categoria: 'Higiene',
      precoCusto: 14.60,
      precoVenda: 22.90,
      quantidade: 42,
      estoqueMinimo: 45,
      dataAdicao: diasAtras(8),
    ),
    Produto(
      nome: 'Shampoo 350ml',
      categoria: 'Higiene',
      precoCusto: 8.70,
      precoVenda: 15.90,
      quantidade: 55,
      estoqueMinimo: 25,
      dataAdicao: diasAtras(5),
    ),
    // Abaixo do mínimo.
    Produto(
      nome: 'Banana prata kg',
      categoria: 'Hortifruti',
      precoCusto: 3.10,
      precoVenda: 5.99,
      quantidade: 28,
      estoqueMinimo: 30,
      dataAdicao: diasAtras(2),
    ),
  ];
}

/// Semeia o exemplo **uma única vez**, na primeira execução.
///
/// Duas travas, porque apagar dado de quem usa o app de verdade é pior do que
/// abrir vazio: só semeia se a box estiver vazia *e* se a flag ainda não
/// existir. Quem esvaziar o estoque de propósito não vê o exemplo voltar
/// sozinho — para isso existe [restaurarExemplo], em Configurações.
Future<void> semearExemploSeNecessario(
  Box<Produto> produtos,
  Box settings,
) async {
  if (settings.get(_seedKey) == true) return;

  if (produtos.isEmpty) {
    await produtos.addAll(produtosExemplo());
  }
  await settings.put(_seedKey, true);
}

/// Substitui todo o conteúdo da box pelo catálogo de demonstração.
///
/// Destrutivo por definição — só chame atrás de uma confirmação explícita.
Future<void> restaurarExemplo(Box<Produto> produtos) async {
  await produtos.clear();
  await produtos.addAll(produtosExemplo());
}
