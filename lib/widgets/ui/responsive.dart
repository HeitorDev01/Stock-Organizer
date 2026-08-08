import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Limita a largura de leitura e aplica o padding de página do breakpoint.
///
/// Sem isso, em monitores largos o conteúdo esticaria até perder a relação
/// entre os blocos.
class ContentContainer extends StatelessWidget {
  const ContentContainer({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.contentMaxWidth,
    this.padding,
  });

  final Widget child;
  final double maxWidth;

  /// Sobrescreve o padding do breakpoint — use quando o filho já reserva a
  /// folga inferior (listas roláveis, por exemplo).
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ??
              (context.isCompact ? AppSpacing.pageCompact : AppSpacing.page),
          child: child,
        ),
      ),
    );
  }
}

/// Grid fluido de cards de métrica.
///
/// O número de colunas vem da largura disponível dividida pela largura-alvo de
/// um card — nunca de uma contagem fixa, que quebraria no desktop.
class MetricGrid extends StatelessWidget {
  const MetricGrid({
    super.key,
    required this.children,
    this.spacing = AppSpacing.md,
    this.targetWidth = AppBreakpoints.metricCardTarget,
    this.maxColumns = 4,
  });

  final List<Widget> children;
  final double spacing;
  final double targetWidth;
  final int maxColumns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double available = constraints.maxWidth;

        int columns = (available / targetWidth).floor();
        if (columns < 1) columns = 1;
        if (columns > maxColumns) columns = maxColumns;
        if (columns > children.length) columns = children.length;

        // Duas colunas ficam melhor que três órfãs quando sobra um item.
        if (columns == 3 && children.length == 4) columns = 2;

        final double itemWidth =
            (available - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((Widget c) => SizedBox(width: itemWidth, child: c))
              .toList(growable: false),
        );
      },
    );
  }
}

/// Duas colunas no desktop, empilhadas no compacto.
class SplitRow extends StatelessWidget {
  const SplitRow({
    super.key,
    required this.start,
    required this.end,
    this.startFlex = 3,
    this.endFlex = 2,
    this.spacing = AppSpacing.md,
    this.breakpoint = AppBreakpoints.compact,
  });

  final Widget start;
  final Widget end;
  final int startFlex;
  final int endFlex;
  final double spacing;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[start, SizedBox(height: spacing), end],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: startFlex, child: start),
            SizedBox(width: spacing),
            Expanded(flex: endFlex, child: end),
          ],
        );
      },
    );
  }
}
