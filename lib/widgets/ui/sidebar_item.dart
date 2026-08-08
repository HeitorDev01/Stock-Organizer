import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Item de navegação da sidebar.
///
/// Seleção é indicada por inversão da superfície — o mesmo recurso usado em
/// todo o app para dar ênfase sem introduzir cor.
class SidebarItem extends StatelessWidget {
  const SidebarItem({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.collapsed = false,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  /// Modo ícone-apenas (sidebar estreita em telas médias).
  final bool collapsed;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    final Color foreground = selected ? t.textInverse : t.textSecondary;
    final Color background = selected ? t.surfaceInverse : Colors.transparent;

    final Widget content = collapsed
        ? Center(child: Icon(icon, size: AppIconSize.md, color: foreground))
        : Row(
            children: <Widget>[
              Icon(icon, size: AppIconSize.md, color: foreground),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.navLabel.copyWith(
                    color: foreground,
                    fontWeight: selected
                        ? AppTypography.semiBold
                        : AppTypography.medium,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          );

    final Widget button = Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Material(
        color: background,
        borderRadius: AppRadii.control,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          hoverColor: selected ? t.surfaceInverseMuted : t.surfaceHover,
          splashFactory: NoSplash.splashFactory,
          borderRadius: AppRadii.control,
          child: Container(
            height: AppSizes.navItemHeight,
            padding: EdgeInsets.symmetric(
              horizontal: collapsed ? 0 : AppSpacing.sm,
            ),
            child: content,
          ),
        ),
      ),
    );

    return collapsed
        ? Tooltip(message: label, waitDuration: AppMotion.slow, child: button)
        : button;
  }
}

/// Rótulo de seção acima de um grupo de [SidebarItem].
class SidebarSectionLabel extends StatelessWidget {
  const SidebarSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.xs,
      ),
      child: Text(
        label.toUpperCase(),
        style: context.text.eyebrow.copyWith(color: context.tokens.textTertiary),
      ),
    );
  }
}

/// Separador entre grupos no modo ícone, onde não há rótulo de seção.
class SidebarSectionDivider extends StatelessWidget {
  const SidebarSectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Divider(height: AppBorders.hairline, color: context.tokens.border),
    );
  }
}
