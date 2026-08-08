import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Marca do app: quadrado invertido com ícone outline + wordmark opcional.
///
/// O símbolo isolado funciona na sidebar em modo ícone; com wordmark, no topo
/// da sidebar expandida e no drawer.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.showWordmark = true});

  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = context.text;

    final Widget mark = Container(
      width: AppSizes.logoMark,
      height: AppSizes.logoMark,
      decoration: BoxDecoration(
        color: t.surfaceInverse,
        borderRadius: AppRadii.nested,
      ),
      child: Icon(
        Icons.layers_outlined,
        size: AppIconSize.md,
        color: t.iconInverse,
      ),
    );

    if (!showWordmark) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        mark,
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Stock',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.titleLarge!.copyWith(
                  color: t.textPrimary,
                  height: 1.1,
                ),
              ),
              Text(
                'ORGANIZE',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.eyebrow.copyWith(color: t.textTertiary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
