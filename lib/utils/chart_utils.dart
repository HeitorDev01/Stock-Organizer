double calcularMaxY(double valor) {
  if (valor <= 100) return 100;
  if (valor <= 500) return 500;
  if (valor <= 1000) return 1000;
  if (valor <= 5000) return 5000;
  if (valor <= 10000) return 10000;
  return (valor / 10000).ceil() * 10000;
}
