import 'package:flutter/material.dart';
import '../models/produto.dart';

class ProdutoTile extends StatelessWidget {
  final Produto produto;
  final VoidCallback? onTap; // Função de Editar
  final VoidCallback onDelete; // Função de Excluir
  final VoidCallback? onInfo; // Função de Detalhes (Opcional)
  final bool mostrarMenu;

  const ProdutoTile({
    super.key,
    required this.produto,
    this.onTap,
    required this.onDelete,
    this.onInfo,
    this.mostrarMenu = true,
  });

  // 👇 Função para deixar a data bonita (Ex: 13/02/2024 às 14:30)
  String _formatarData(DateTime data) {
    String dia = data.day.toString().padLeft(2, '0');
    String mes = data.month.toString().padLeft(2, '0');
    String ano = data.year.toString();
    String hora = data.hour.toString().padLeft(2, '0');
    String min = data.minute.toString().padLeft(2, '0');
    
    return "$dia/$mes/$ano às $hora:$min";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap, 
        
        leading: CircleAvatar(
          backgroundColor: produto.estoqueBaixo 
              ? Colors.red.shade100 
              : Colors.blue.shade100,
          child: Icon(
            produto.estoqueBaixo ? Icons.warning_rounded : Icons.inventory_2_rounded,
            color: produto.estoqueBaixo ? Colors.red : const Color(0xFF1565C0),
            size: 22,
          ),
        ),
        
        title: Text(
          produto.nome,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        
        // 👇 AQUI A MUDANÇA NO SUBTITLE
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Categoria: ${produto.categoria}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            
            const SizedBox(height: 2),
            Text(
              'Qtd: ${produto.quantidade}  |  Venda: R\$ ${produto.precoVenda.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
            ),

            const SizedBox(height: 6), // Espacinho extra antes da data
            
            // Linha da Data e Hora
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 12, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(
                  "Add: ${_formatarData(produto.dataAdicao)}",
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
              ],
            )
          ],
        ),
        
        trailing: mostrarMenu
            ? PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (value) {
                  switch (value) {
                    case 'info':
                      if (onInfo != null) onInfo!();
                      break;
                    case 'edit':
                      if (onTap != null) onTap!();
                      break;
                    case 'delete':
                      _confirmarExclusao(context);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, color: Color(0xFF1565C0), size: 20),
                        SizedBox(width: 12),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  if (onInfo != null)
                    const PopupMenuItem(
                      value: 'info',
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: Colors.grey, size: 20),
                          SizedBox(width: 12),
                          Text('Detalhes'),
                        ],
                      ),
                    ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                        SizedBox(width: 12),
                        Text('Excluir', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Excluir Produto?'),
        content: Text('Tem certeza que deseja remover "${produto.nome}" do estoque? Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context); 
              onDelete(); 
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}