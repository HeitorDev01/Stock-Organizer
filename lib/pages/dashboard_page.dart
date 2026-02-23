import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../charts/lucro_por_categoria_chart.dart';
import '../charts/evolucao_lucro_chart.dart';
import '../charts/top_produto_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Cores do Tema (Padronizado)
  final primaryBlue = const Color(0xFF1565C0);
  final lightBlue = const Color(0xFF42A5F5);
  final bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: primaryBlue,
      body: Column(
        children: [
          // 1. CABEÇALHO PERSONALIZADO (COM BOTÃO DE VOLTAR CORRIGIDO)
          _buildHeader(),

          // 2. CONTEÚDO (Corpo com efeito de "folha")
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor, 
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 BLOCO 1 — EVOLUÇÃO
                      const _ChartCard(
                        title: "Evolução Mensal",
                        icon: Icons.show_chart,
                        iconColor: Colors.blue,
                        child: EvolucaoLucroChart(),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 BLOCO 2 — CATEGORIA
                      const _ChartCard(
                        title: "Distribuição por Categoria",
                        icon: Icons.pie_chart,
                        iconColor: Colors.orange,
                        child: LucroPorCategoriaChart(),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 BLOCO 3 — TOP PRODUTOS
                      const _ChartCard(
                        title: "Top 5 Produtos Rentáveis",
                        icon: Icons.star,
                        iconColor: Colors.amber,
                        child: TopProdutosChart(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryBlue, lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Título e Ícone Esquerdo (CORRIGIDO AQUI)
          Row(
            children: [
              // Lógica: Se puder voltar, mostra a seta. Se não, mostra o ícone do painel.
              if (Navigator.canPop(context))
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              
              const SizedBox(width: 16),
              
              const Text(
                'Painel Financeiro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderActionButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// 🎨 WIDGET DECORATIVO DOS GRÁFICOS
class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData icon;
  final Color iconColor;

  const _ChartCard({
    required this.title,
    required this.child,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          child,
        ],
      ),
    );
  }
  Widget _buildLegendaItem(Color cor, String titulo) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Ocupa só o espaço necessário
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Bolinha redonda
            color: cor,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          titulo,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}