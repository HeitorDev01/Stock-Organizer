import 'package:flutter/material.dart';
import '../models/produto.dart';

class ResumoEstoque extends StatelessWidget {
  final List<Produto> produtos;

  const ResumoEstoque({super.key, required this.produtos});

  @override
  Widget build(BuildContext context) {
    final totalItens =
        produtos.fold<int>(0, (sum, p) => sum + p.quantidade);

    final produtosBaixos =
        produtos.where((p) => p.estoqueBaixo).length;

    final lucroTotal = produtos.fold<double>(
      0,
      (sum, p) =>
          sum + ((p.precoVenda - p.precoCusto) * p.quantidade),
    );

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }
}

class _ItemResumo extends StatelessWidget {
  final String label;
  final String valor;
  final IconData icon;
  final Color? cor;

  const _ItemResumo({
    required this.label,
    required this.valor,
    required this.icon,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: cor ?? Colors.blue),
        const SizedBox(height: 4),
        Text(valor,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label),
      ],
    );
  }
}
