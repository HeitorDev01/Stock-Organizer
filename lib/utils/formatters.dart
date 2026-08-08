/// Formatação numérica pt-BR feita à mão para não introduzir a dependência
/// `intl` só por causa de separador de milhar.
///
/// Camada de apresentação: nenhum cálculo acontece aqui, só formatação.
library;

/// Insere ponto como separador de milhar: `1234567` → `1.234.567`.
String _groupThousands(String digits) {
  final StringBuffer out = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write('.');
    out.write(digits[i]);
  }
  return out.toString();
}

/// `1234` → `1.234`
String formatInt(int value) {
  final bool negative = value < 0;
  final String digits = value.abs().toString();
  return '${negative ? '-' : ''}${_groupThousands(digits)}';
}

/// `1234.5` → `R$ 1.234,50`
String formatBRL(double value) {
  final bool negative = value < 0;
  final String fixed = value.abs().toStringAsFixed(2);
  final int dot = fixed.indexOf('.');
  final String whole = _groupThousands(fixed.substring(0, dot));
  final String cents = fixed.substring(dot + 1);
  return '${negative ? '-' : ''}R\$ $whole,$cents';
}

/// Versão curta para eixos de gráfico: `1500` → `1,5 mil`, `2400000` → `2,4 mi`.
String formatCompact(double value) {
  final double abs = value.abs();
  final String sign = value < 0 ? '-' : '';

  if (abs >= 1000000) {
    return '$sign${_trim(abs / 1000000)} mi';
  }
  if (abs >= 1000) {
    return '$sign${_trim(abs / 1000)} mil';
  }
  return '$sign${abs.toStringAsFixed(0)}';
}

/// Igual a [formatCompact], prefixado com `R$`.
String formatCompactBRL(double value) => 'R\$ ${formatCompact(value)}';

/// Uma casa decimal, vírgula no lugar do ponto, sem `,0` inútil.
String _trim(double value) {
  final String s = value.toStringAsFixed(1);
  return (s.endsWith('.0') ? s.substring(0, s.length - 2) : s)
      .replaceAll('.', ',');
}

/// `13/02/2026`
String formatDate(DateTime date) {
  final String d = date.day.toString().padLeft(2, '0');
  final String m = date.month.toString().padLeft(2, '0');
  return '$d/$m/${date.year}';
}

/// Rótulo curto de mês: `fev`.
String formatMonthShort(DateTime date) {
  const List<String> months = <String>[
    'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
    'jul', 'ago', 'set', 'out', 'nov', 'dez',
  ];
  return months[date.month - 1];
}
