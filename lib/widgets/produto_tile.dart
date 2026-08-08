import 'package:flutter/material.dart';

import '../models/produto.dart';
import '../theme/theme.dart';
import 'ui/app_card.dart';
import 'ui/status_pill.dart';

/// Linha horizontal de produto.
///
/// A API pública é a mesma de antes (`produto`, `onTap`, `onDelete`, `onInfo`,
/// `mostrarMenu`) — só a camada visual mudou.
class ProdutoTile extends StatelessWidget {
  final Produto produto;
  final VoidCallback? onTap; // Função de Editar
  final VoidCallback onDelete; // Função de Excluir
  final VoidCallback? onInfo; // Função de Detalhes (Opcional)
  final bool mostrarMenu;

  /// Versão reduzida usada na lista de "itens recentes" do painel.
  final bool dense;

  const ProdutoTile({
    super.key,
    required this.produto,
    this.onTap,
    required this.onDelete,
    this.onInfo,
    this.mostrarMenu = true,
    this.dense = false,
  });

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
    final t = context.tokens;
    final text = context.text;
    final bool baixo = produto.estoqueBaixo;
    final bool compact = context.isCompact;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(dense ? AppSpacing.md : AppSpacing.lg),
      borderRadius: AppRadii.cardSmall,
      child: Row(
        children: <Widget>[
          // Marcador: quadrado outline. Invertido quando o estoque está baixo —
          // é assim que o sistema sinaliza urgência sem usar vermelho.
          Container(
            width: dense ? AppSpacing.xxxl : AppSpacing.huge - AppSpacing.xs,
            height: dense ? AppSpacing.xxxl : AppSpacing.huge - AppSpacing.xs,
            decoration: BoxDecoration(
              color: baixo ? t.surfaceInverse : t.surfaceMuted,
              borderRadius: AppRadii.nested,
              border: Border.all(
                color: baixo ? t.surfaceInverse : t.border,
                width: AppBorders.hairline,
              ),
            ),
            child: Icon(
              baixo
                  ? Icons.error_outline_rounded
                  : Icons.inventory_2_outlined,
              size: AppIconSize.md,
              color: baixo ? t.iconInverse : t.iconSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Nome + metadados
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  produto.nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.itemTitle.copyWith(color: t.textPrimary),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${produto.categoria} · R\$ ${produto.precoVenda.toStringAsFixed(2)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.itemMeta.copyWith(color: t.textSecondary),
                ),
                if (!dense && !compact) ...<Widget>[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Adicionado em ${_formatarData(produto.dataAdicao)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall!.copyWith(color: t.textTertiary),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Quantidade — o número é a informação, alinhado à direita.
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${produto.quantidade}',
                style: (dense ? text.titleLarge! : text.headlineSmall!)
                    .copyWith(color: t.textPrimary),
              ),
              const SizedBox(height: AppSpacing.xxs / 2),
              if (baixo)
                const StatusPill(label: 'Repor', tone: PillTone.solid)
              else
                Text(
                  'em estoque',
                  style: text.bodySmall!.copyWith(color: t.textTertiary),
                ),
            ],
          ),

          if (mostrarMenu) ...<Widget>[
            const SizedBox(width: AppSpacing.xs),
            _ProdutoMenu(
              onEdit: onTap,
              onInfo: onInfo,
              onDelete: () => _confirmarExclusao(context),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmarExclusao(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Excluir produto?'),
        content: Text(
          'Tem certeza que deseja remover "${produto.nome}" do estoque? '
          'Essa ação não pode ser desfeita.',
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        actions: <Widget>[
          OutlinedButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onDelete();
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

class _ProdutoMenu extends StatelessWidget {
  const _ProdutoMenu({
    required this.onEdit,
    required this.onInfo,
    required this.onDelete,
  });

  final VoidCallback? onEdit;
  final VoidCallback? onInfo;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return PopupMenuButton<String>(
      tooltip: 'Ações',
      position: PopupMenuPosition.under,
      icon: Icon(
        Icons.more_horiz_outlined,
        size: AppIconSize.md,
        color: t.iconSecondary,
      ),
      onSelected: (String value) {
        switch (value) {
          case 'info':
            onInfo?.call();
          case 'edit':
            onEdit?.call();
          case 'delete':
            onDelete();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'edit',
          child: _MenuRow(icon: Icons.edit_outlined, label: 'Editar'),
        ),
        if (onInfo != null)
          const PopupMenuItem<String>(
            value: 'info',
            child: _MenuRow(icon: Icons.info_outlined, label: 'Detalhes'),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'delete',
          child: _MenuRow(icon: Icons.delete_outline, label: 'Excluir'),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Row(
      children: <Widget>[
        Icon(icon, size: AppIconSize.sm, color: t.iconSecondary),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: context.text.bodyMedium!.copyWith(
          color: t.textPrimary,
        )),
      ],
    );
  }
}
