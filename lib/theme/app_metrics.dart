import 'package:flutter/widgets.dart';

/// ---------------------------------------------------------------------------
/// ESCALAS NUMÉRICAS DO DESIGN SYSTEM
///
/// Nenhum widget deve escrever um número cru de espaçamento, raio, tamanho de
/// ícone ou duração. Tudo vem daqui.
/// ---------------------------------------------------------------------------

/// Escala de espaçamento em base 4pt.
abstract final class AppSpacing {
  /// 4 — separação entre um rótulo e o valor que ele descreve.
  static const double xxs = 4;

  /// 8 — separação entre elementos irmãos muito próximos.
  static const double xs = 8;

  /// 12 — respiro interno de controles pequenos (pills, chips).
  static const double sm = 12;

  /// 16 — gutter padrão de listas.
  static const double md = 16;

  /// 20 — padding interno de cards compactos.
  static const double lg = 20;

  /// 24 — padding interno padrão de card.
  static const double xl = 24;

  /// 32 — separação entre cards de uma mesma seção.
  static const double xxl = 32;

  /// 40 — separação entre seções distintas da página.
  static const double xxxl = 40;

  /// 56 — respiro do topo do conteúdo.
  static const double huge = 56;

  /// 96 — folga do rodapé para o conteúdo nunca colar na borda.
  static const double giant = 96;

  static const EdgeInsets card = EdgeInsets.all(xl);
  static const EdgeInsets cardCompact = EdgeInsets.all(lg);
  static const EdgeInsets page = EdgeInsets.fromLTRB(xxl, xl, xxl, giant);
  static const EdgeInsets pageCompact = EdgeInsets.fromLTRB(md, md, md, giant);
}

/// Raios de canto. A direção estética pede 16–24; nada abaixo de 12.
abstract final class AppRadii {
  /// 12 — controles internos (inputs, botões pequenos).
  static const double sm = 12;

  /// 16 — elementos aninhados dentro de um card.
  static const double md = 16;

  /// 20 — cards secundários.
  static const double lg = 20;

  /// 24 — cards principais.
  static const double xl = 24;

  /// Totalmente arredondado (pills, avatares).
  static const double pill = 999;

  static const BorderRadius card = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius cardSmall = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius nested = BorderRadius.all(Radius.circular(md));
  static const BorderRadius control = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius round = BorderRadius.all(Radius.circular(pill));
}

/// Espessuras de borda. Substituem completamente as sombras pesadas.
abstract final class AppBorders {
  /// 1px — a única espessura de borda do sistema.
  static const double hairline = 1;

  /// 1.5px — estado de foco/seleção, ainda discreto.
  static const double focus = 1.5;
}

/// Elevação. O sistema é praticamente plano: profundidade vem de contraste.
abstract final class AppElevation {
  /// Padrão absoluto — superfícies não flutuam.
  static const double none = 0;

  /// Único caso de elevação real: overlays que precisam sair do plano.
  static const double overlay = 2;
}

/// Tamanhos de ícone. Sempre variantes *outline*, nunca preenchidas.
abstract final class AppIconSize {
  static const double xs = 14;
  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
  static const double xl = 28;
  static const double empty = 44;
}

/// Durações e curvas de animação.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration normal = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 420);

  /// Escalonamento entre itens de uma lista que entra em cascata.
  static const Duration stagger = Duration(milliseconds: 45);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutQuart;
}

/// Pontos de quebra e larguras estruturais do layout.
abstract final class AppBreakpoints {
  /// Abaixo disso: navegação inferior, uma coluna.
  static const double compact = 720;

  /// Entre [compact] e este valor: sidebar reduzida a ícones.
  static const double medium = 1100;

  /// Largura da sidebar expandida.
  static const double sidebarExpanded = 264;

  /// Largura da sidebar em modo ícone.
  static const double sidebarRail = 80;

  /// Trava a leitura em telas ultra-largas.
  static const double contentMaxWidth = 1440;

  /// Largura alvo de um card de métrica — governa as colunas do grid.
  static const double metricCardTarget = 220;

  static bool isCompact(double width) => width < compact;
  static bool isMedium(double width) => width >= compact && width < medium;
  static bool isExpanded(double width) => width >= medium;
}

/// Alturas fixas de componentes estruturais.
abstract final class AppSizes {
  static const double headerHeight = 88;
  static const double headerHeightCompact = 72;
  static const double controlHeight = 48;
  static const double avatar = 40;
  static const double navItemHeight = 46;
  static const double chartHeight = 260;
  static const double chartHeightCompact = 220;
  static const double logoMark = 40;
}
