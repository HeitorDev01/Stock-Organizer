import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'app_search_field.dart';

/// Header do shell: saudação personalizada, busca, notificações e avatar.
///
/// Em telas estreitas a busca sai da linha e o botão de menu entra — o header
/// nunca comprime os alvos de toque.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.userName,
    required this.pageTitle,
    required this.searchController,
    required this.onSearchSubmitted,
    required this.onNotifications,
    required this.onAvatarTap,
    this.alertCount = 0,
    this.onMenu,
  });

  final String userName;
  final String pageTitle;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onNotifications;
  final VoidCallback onAvatarTap;
  final int alertCount;

  /// Só existe no layout compacto, onde a sidebar vira drawer.
  final VoidCallback? onMenu;

  /// Saudação por faixa horária — o toque "personalizado" pedido no header.
  static String greetingFor(DateTime now) {
    if (now.hour < 12) return 'Bom dia';
    if (now.hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = context.text;
    final bool compact = context.isCompact;

    final Widget greeting = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '${greetingFor(DateTime.now())}, $userName',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.headlineSmall!.copyWith(color: t.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xxs / 2),
        Text(
          pageTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.bodySmall!.copyWith(color: t.textTertiary),
        ),
      ],
    );

    final Widget actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SoftIconButton(
          icon: Icons.notifications_none_outlined,
          tooltip: 'Alertas de estoque',
          badgeCount: alertCount,
          onPressed: onNotifications,
        ),
        const SizedBox(width: AppSpacing.sm),
        _Avatar(name: userName, onTap: onAvatarTap),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        color: t.canvas,
        border: Border(
          bottom: BorderSide(color: t.border, width: AppBorders.hairline),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? AppSpacing.md : AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          child: compact
              ? _CompactLayout(
                  onMenu: onMenu,
                  greeting: greeting,
                  actions: actions,
                  searchController: searchController,
                  onSearchSubmitted: onSearchSubmitted,
                )
              : Row(
                  children: <Widget>[
                    Expanded(flex: 4, child: greeting),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      flex: 5,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: AppSearchField(
                          hintText: 'Buscar produto ou categoria...',
                          controller: searchController,
                          onSubmitted: onSearchSubmitted,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    actions,
                  ],
                ),
        ),
      ),
    );
  }
}

class _CompactLayout extends StatelessWidget {
  const _CompactLayout({
    required this.onMenu,
    required this.greeting,
    required this.actions,
    required this.searchController,
    required this.onSearchSubmitted,
  });

  final VoidCallback? onMenu;
  final Widget greeting;
  final Widget actions;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            if (onMenu != null) ...<Widget>[
              SoftIconButton(
                icon: Icons.menu_outlined,
                tooltip: 'Menu',
                onPressed: onMenu!,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(child: greeting),
            const SizedBox(width: AppSpacing.sm),
            actions,
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppSearchField(
          hintText: 'Buscar produto...',
          controller: searchController,
          onSubmitted: onSearchSubmitted,
        ),
      ],
    );
  }
}

/// Avatar de iniciais — sem foto, sem cor: apenas contraste.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  String get _initials {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Tooltip(
      message: 'Conta e preferências',
      child: Material(
        color: t.surfaceInverse,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          hoverColor: t.surfaceInverseMuted,
          splashFactory: NoSplash.splashFactory,
          child: SizedBox(
            width: AppSizes.avatar,
            height: AppSizes.avatar,
            child: Center(
              child: Text(
                _initials,
                style: context.text.labelLarge!.copyWith(
                  color: t.textInverse,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
