import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Estado vazio padrão: ícone outline grande e leve, título e apoio.
///
/// Centraliza as quatro variações que existiam espalhadas pelas telas.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = context.text;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: AppSpacing.huge + AppSpacing.md,
              height: AppSpacing.huge + AppSpacing.md,
              decoration: BoxDecoration(
                color: t.surfaceMuted,
                shape: BoxShape.circle,
                border: Border.all(
                  color: t.border,
                  width: AppBorders.hairline,
                ),
              ),
              child: Icon(
                icon,
                size: AppIconSize.xl,
                color: t.iconSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: text.titleLarge!.copyWith(color: t.textPrimary),
            ),
            if (message != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: text.bodyMedium!.copyWith(color: t.textTertiary),
                ),
              ),
            ],
            if (action != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
