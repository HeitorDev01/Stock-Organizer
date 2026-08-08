import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Abre uma seção da página: eyebrow em caixa alta + título + ação opcional.
///
/// O eyebrow existe para dar hierarquia sem recorrer a cor.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.trailing,
    this.padding = const EdgeInsets.only(bottom: AppSpacing.md),
  });

  final String title;
  final String? eyebrow;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = context.text;

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (eyebrow != null) ...<Widget>[
                  Text(
                    eyebrow!.toUpperCase(),
                    style: text.eyebrow.copyWith(color: t.textTertiary),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                ],
                Text(
                  title,
                  style: text.sectionTitle.copyWith(color: t.textPrimary),
                ),
              ],
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}
