import 'package:flutter/material.dart';        // UI (Cards, Cores, Ícones)
import 'package:hive_flutter/hive_flutter.dart'; // Banco de Dados
import 'package:fl_chart/fl_chart.dart';       // Gráfico de Rosca (PieChart)
import '../models/produto.dart';               // Seu modelo de Produto

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08), // Sombra muito leve
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Cabeçalho do Card (Ícone + Indicador visual)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Ícone com fundo colorido suave
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12), // Fundo transparente da mesma cor
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              // Pequeno indicador visual (opcional, dá charme)
              Icon(
                Icons.arrow_outward_rounded,
                color: Colors.grey[300],
                size: 18,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 2. O Valor (Número Grande)
          Text(
            value,
            style: const TextStyle(
              fontSize: 28, // Bem grande para leitura rápida
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3436),
              height: 1.0, // Remove espaçamento extra da fonte
            ),
          ),
          
          const SizedBox(height: 6),
          
          // 3. O Título (Texto menor cinza)
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}