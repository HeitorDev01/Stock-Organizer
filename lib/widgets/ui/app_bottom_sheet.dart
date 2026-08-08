import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Moldura única de todos os bottom sheets: handle, eyebrow, título e corpo
/// rolável com altura limitada.
///
/// Antes cada tela desenhava seu próprio sheet com paddings e handles
/// diferentes.
Future<T?> showAppSheet<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  String? eyebrow,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    showDragHandle: false,
    backgroundColor: Colors.transparent,
    barrierColor: context.tokens.overlayScrim,
    builder: (BuildContext ctx) => _AppSheetFrame(
      title: title,
      eyebrow: eyebrow,
      child: child,
    ),
  );
}

class _AppSheetFrame extends StatelessWidget {
  const _AppSheetFrame({
    required this.title,
    required this.child,
    this.eyebrow,
  });

  final String title;
  final String? eyebrow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = context.text;
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.82;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.xl),
        ),
        border: Border.all(color: t.border, width: AppBorders.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Center(
                child: Container(
                  width: AppSpacing.xxxl,
                  height: AppSpacing.xxs,
                  decoration: BoxDecoration(
                    color: t.borderStrong,
                    borderRadius: AppRadii.round,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (eyebrow != null) ...<Widget>[
                          Text(
                            eyebrow!.toUpperCase(),
                            style: text.eyebrow
                                .copyWith(color: t.textTertiary),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                        ],
                        Text(
                          title,
                          style: text.headlineSmall!
                              .copyWith(color: t.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Fechar',
                    icon: Icon(
                      Icons.close_outlined,
                      size: AppIconSize.md,
                      color: t.iconSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  0,
                  AppSpacing.xl,
                  AppSpacing.xl,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
