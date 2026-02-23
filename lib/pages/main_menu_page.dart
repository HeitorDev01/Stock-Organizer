import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:estoque_app/pages/add_produto_page.dart';
import 'package:estoque_app/pages/estoque_page.dart';
import 'package:estoque_app/pages/visao_geral_page.dart';
import 'dashboard_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a barra de status para combinar com o design
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Fundo cinza azulado claro
      body: Column(
        children: [
          // 1. CABEÇALHO PERSONALIZADO (Header)
          _buildHeader(),

          // 2. GRID DE MENUS
         Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              // Transformando o Container para subir um pouco sobre o header
              child: Transform.translate(
                offset: const Offset(0, -40),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85, 
                  padding: const EdgeInsets.only(bottom: 20),
                  children: [
                    // 1. ESTOQUE (Entra imediatamente: delay 0)
                    FadeInAnimation(
                      delay: 0, 
                      child: _ModernMenuCard(
                        title: 'Estoque',
                        subtitle: 'Gerenciar itens',
                        icon: Icons.inventory_2_rounded,
                        color: const Color(0xFF2E86DE),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EstoquePage())),
                      ),
                    ),

                    // 2. VISÃO GERAL (Entra depois de 100ms)
                    FadeInAnimation(
                      delay: 100,
                      child: _ModernMenuCard(
                        title: 'Visão Geral',
                        subtitle: 'Alertas e status',
                        icon: Icons.dashboard_customize_rounded,
                        color: const Color(0xFFFF9F43),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VisaoGeralPage())),
                      ),
                    ),

                    // 3. NOVO PRODUTO (Entra depois de 200ms)
                    FadeInAnimation(
                      delay: 200,
                      child: _ModernMenuCard(
                        title: 'Novo Produto',
                        subtitle: 'Cadastrar',
                        icon: Icons.add_circle_outline_rounded,
                        color: const Color(0xFF10AC84),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProdutoPage())),
                      ),
                    ),

                    // 4. DASHBOARD (Entra depois de 300ms)
                    FadeInAnimation(
                      delay: 300,
                      child: _ModernMenuCard(
                        title: 'Dashboard',
                        subtitle: 'Gráficos e KPIs',
                        icon: Icons.pie_chart_rounded,
                        color: const Color(0xFF5F27CD),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardPage())),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 280, // Altura maior para dar destaque
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text(
                'Bem-vindo ao',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Stock Organize',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 40), // Espaço extra para o Grid subir
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ModernMenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15), // Sombra da cor do card
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Ícone com fundo colorido
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              
              // Textos
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}// Widget utilitário para animação de entrada
class FadeInAnimation extends StatelessWidget {
  final int delay;
  final Widget child;

  const FadeInAnimation({super.key, required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuart, // Curva suave (começa rápido, termina lento)
      builder: (context, value, child) {
        // O item começa 50px para baixo e sobe enquanto fica opaco
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)), 
            child: child,
          ),
        );
      },
      // Aplica o atraso (delay) antes de começar
      onEnd: () {},
      child: FutureBuilder(
        future: Future.delayed(Duration(milliseconds: delay)),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? child
              : const SizedBox.shrink(); // Esconde até dar o tempo do delay
        },
      ),
    );
  }
}