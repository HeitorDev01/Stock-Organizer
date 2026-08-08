import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Campo de busca do sistema — usado no header e nas listas.
///
/// Pill de 1px sem sombra: o campo se distingue do fundo por borda, não por
/// profundidade.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.trailing,
    this.autofocus = false,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Ação à direita (ex.: botão de filtro).
  final Widget? trailing;

  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return SizedBox(
      height: AppSizes.controlHeight,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        autofocus: autofocus,
        textInputAction: TextInputAction.search,
        style: context.text.bodyMedium!.copyWith(color: t.textPrimary),
        cursorColor: t.textPrimary,
        cursorWidth: AppBorders.focus,
        decoration: InputDecoration(
          hintText: hintText,
          isDense: true,
          filled: true,
          fillColor: t.surface,
          prefixIcon: Icon(
            Icons.search_outlined,
            size: AppIconSize.md,
            color: t.iconSecondary,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: AppSizes.controlHeight,
            minHeight: AppSizes.controlHeight,
          ),
          suffixIcon: trailing == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xxs),
                  child: trailing,
                ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.md,
          ),
          border: OutlineInputBorder(
            borderRadius: AppRadii.round,
            borderSide: BorderSide(color: t.border, width: AppBorders.hairline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadii.round,
            borderSide: BorderSide(color: t.border, width: AppBorders.hairline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadii.round,
            borderSide: BorderSide(
              color: t.textPrimary,
              width: AppBorders.focus,
            ),
          ),
        ),
      ),
    );
  }
}

/// Botão de ícone quadrado com borda hairline — o par visual do campo de busca.
class SoftIconButton extends StatelessWidget {
  const SoftIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.active = false,
    this.badgeCount,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  /// Estado ligado: inverte a superfície em vez de colorir.
  final bool active;

  /// Contador sobreposto (0 ou nulo esconde o indicador).
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final bool hasBadge = (badgeCount ?? 0) > 0;

    Widget button = Material(
      color: active ? t.surfaceInverse : t.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.control,
        side: BorderSide(
          color: active ? t.surfaceInverse : t.border,
          width: AppBorders.hairline,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        hoverColor: active ? t.surfaceInverseMuted : t.surfaceHover,
        splashFactory: NoSplash.splashFactory,
        child: SizedBox(
          width: AppSizes.controlHeight,
          height: AppSizes.controlHeight,
          child: Icon(
            icon,
            size: AppIconSize.md,
            color: active ? t.iconInverse : t.iconPrimary,
          ),
        ),
      ),
    );

    if (hasBadge) {
      button = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          button,
          Positioned(
            top: -AppSpacing.xxs,
            right: -AppSpacing.xxs,
            child: Container(
              constraints: const BoxConstraints(minWidth: AppSpacing.lg),
              height: AppSpacing.lg,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: t.surfaceInverse,
                borderRadius: AppRadii.round,
                border: Border.all(color: t.canvas, width: AppBorders.focus),
              ),
              child: Text(
                badgeCount! > 99 ? '99+' : '$badgeCount',
                style: context.text.labelSmall!.copyWith(
                  color: t.textInverse,
                  letterSpacing: 0,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return tooltip == null
        ? button
        : Tooltip(message: tooltip!, child: button);
  }
}
