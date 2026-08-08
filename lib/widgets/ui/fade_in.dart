import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Entrada suave: opacidade + deslocamento vertical curto.
///
/// Substitui as três cópias divergentes de `FadeInAnimation` que existiam em
/// `main_menu_page`, `estoque_page` e `visao_geral_page`.
class FadeIn extends StatefulWidget {
  const FadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offsetY = AppSpacing.md,
  });

  /// Atraso em cascata a partir da posição do item numa lista.
  ///
  /// Não pode ser `const`: o atraso é calculado a partir do índice.
  // ignore: prefer_const_constructors_in_immutables
  FadeIn.staggered({
    super.key,
    required this.child,
    required int index,
    this.offsetY = AppSpacing.md,
    int maxSteps = 8,
  }) : delay = AppMotion.stagger * (index < maxSteps ? index : maxSteps);

  final Widget child;
  final Duration delay;
  final double offsetY;

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _visible = true;
    } else {
      _timer = Timer(widget.delay, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : Offset(0, widget.offsetY / 100),
      duration: AppMotion.slow,
      curve: AppMotion.emphasized,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: AppMotion.normal,
        curve: AppMotion.standard,
        child: widget.child,
      ),
    );
  }
}
