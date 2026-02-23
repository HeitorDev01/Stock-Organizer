import 'package:flutter/material.dart';
import '../models/produto.dart';

class Dashboard extends StatelessWidget {
  final List<Produto> produtos;

  const Dashboard({super.key, required this.produtos});

  int get totalItens =>
      produtos.fold(0, (soma, p) => soma + p.quantidade);

  double get valorTotalEstoque =>
      produtos.fold(0, (soma, p) => soma + (p.precoCusto * p.quantidade));

  bool get temEstoqueBaixo =>
      produtos.any((p) => p.estoqueBaixo);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Resumo do Estoque',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Text('🧾 Produtos Cadastrados: ${produtos.length}'),
            Text('📦 Itens em Estoque: $totalItens'),
            Text(
              '💰 Valor em Estoque: R\$ ${valorTotalEstoque.toStringAsFixed(2)}',
            ),

            if (temEstoqueBaixo) ...[
              const SizedBox(height: 10),
              Row(
                children: const [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 6),
                  Text(
                    'Existe produto com estoque baixo',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
