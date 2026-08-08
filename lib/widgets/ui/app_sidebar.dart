import 'package:flutter/material.dart';

import '../../navigation/app_destination.dart';
import '../../theme/theme.dart';
import 'app_logo.dart';
import 'sidebar_item.dart';

/// Navegação lateral: logo no topo, itens agrupados por seção, e
/// Configurações ancorada na base.
///
/// [collapsed] reduz a coluna a ícones em telas de largura média.
class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.selected,
    required this.onSelect,
    this.collapsed = false,
    this.showBorder = true,
  });

  final AppDestination selected;
  final ValueChanged<AppDestination> onSelect;
  final bool collapsed;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final Map<NavSection, List<AppDestination>> groups =
        AppDestination.grouped;

    return Container(
      width: collapsed
          ? AppBreakpoints.sidebarRail
          : AppBreakpoints.sidebarExpanded,
      decoration: BoxDecoration(
        color: t.surface,
        border: showBorder
            ? Border(
                right: BorderSide(
                  color: t.border,
                  width: AppBorders.hairline,
                ),
              )
            : null,
      ),
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // --- Logo ---
            Padding(
              padding: EdgeInsets.fromLTRB(
                collapsed ? AppSpacing.lg : AppSpacing.xl,
                AppSpacing.xl,
                collapsed ? AppSpacing.lg : AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: AppLogo(showWordmark: !collapsed),
            ),

            // --- Itens agrupados ---
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: collapsed ? AppSpacing.md : AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    for (final MapEntry<NavSection, List<AppDestination>> entry
                        in groups.entries) ...<Widget>[
                      if (collapsed)
                        const SidebarSectionDivider()
                      else
                        SidebarSectionLabel(label: entry.key.label),
                      for (final AppDestination d in entry.value)
                        SidebarItem(
                          label: d.label,
                          icon: d.icon,
                          collapsed: collapsed,
                          selected: selected == d,
                          onTap: () => onSelect(d),
                        ),
                    ],
                  ],
                ),
              ),
            ),

            // --- Configurações fixa na base ---
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(
                    height: AppSpacing.xl,
                    color: t.border,
                    thickness: AppBorders.hairline,
                  ),
                  SidebarItem(
                    label: AppDestination.configuracoes.label,
                    icon: AppDestination.configuracoes.icon,
                    collapsed: collapsed,
                    selected: selected == AppDestination.configuracoes,
                    onTap: () => onSelect(AppDestination.configuracoes),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
