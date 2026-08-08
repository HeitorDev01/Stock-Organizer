import 'package:flutter/material.dart';

import '../models/produto.dart';
import '../theme/theme.dart';
import 'ui/app_bottom_sheet.dart';
import 'ui/app_card.dart';
import 'ui/empty_state.dart';
import 'ui/status_pill.dart';

/// Sheet de alertas de estoque baixo.
///
/// Fonte única para o sino do header e para o botão de alertas da Visão Geral —
/// antes eram duas implementações separadas.
Future<void> showLowStockSheet(
  BuildContext context,
  List<Produto> alertas, {
  VoidCallback? onVerEstoque,
}) {
  return showAppSheet<void>(
    context: context,
    eyebrow: 'Reposição',
    title: alertas.isEmpty
        ? 'Nenhum alerta'
        : '${alertas.length} ${alertas.length == 1 ? "item precisa" : "itens precisam"} de atenção',
    child: alertas.isEmpty
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: EmptyState(
              icon: Icons.check_circle_outline,
              title: 'Tudo sob controle',
              message: 'Nenhum produto está abaixo do estoque mínimo.',
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final Produto p in alertas)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _AlertRow(produto: p),
                ),
              if (onVerEstoque != null) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onVerEstoque();
                  },
                  icon: const Icon(
                    Icons.arrow_forward_outlined,
                    size: AppIconSize.sm,
                  ),
                  label: const Text('Abrir estoque'),
                ),
              ],
            ],
          ),
  );
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({required this.produto});

  final Produto produto;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = context.text;

    return AppCard(
      tone: AppCardTone.muted,
      padding: const EdgeInsets.all(AppSpacing.md),
      borderRadius: AppRadii.nested,
      child: Row(
        children: <Widget>[
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
                  'Restam ${produto.quantidade} · mínimo ${produto.estoqueMinimo}',
                  style: text.itemMeta.copyWith(color: t.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const StatusPill(label: 'Repor', tone: PillTone.solid),
        ],
      ),
    );
  }
}
