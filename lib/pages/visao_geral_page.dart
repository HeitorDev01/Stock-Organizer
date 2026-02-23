import 'package:estoque_app/pages/estoque_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/produto.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class VisaoGeralPage extends StatefulWidget {
  const VisaoGeralPage({super.key});

  @override
  State<VisaoGeralPage> createState() => _VisaoGeralPageState();
}

class _VisaoGeralPageState extends State<VisaoGeralPage> {
  late Box<Produto> produtoBox;
  
  // Cores do Tema (Iguais ao EstoquePage)
  final primaryBlue = const Color(0xFF1565C0);
  final lightBlue = const Color(0xFF42A5F5);
  final bgColor = const Color(0xFFF5F7FA);

  @override
  void initState() {
    super.initState();
    produtoBox = Hive.box<Produto>('produtos');
  }

  @override
  Widget build(BuildContext context) {
    // Configura a barra de status
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: primaryBlue, // Fundo azul para o "notch"
      body: Column(
        children: [
          // 1. CABEÇALHO PERSONALIZADO
          _buildHeader(),

          // 2. CORPO BRANCO ARREDONDADO
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
                // CONTEÚDO ORIGINAL (COM HIVE)
                child: ValueListenableBuilder(
                  valueListenable: produtoBox.listenable(),
                  builder: (context, Box<Produto> box, _) {
                    final produtos = box.values.toList();
                    
                    final totalProdutos = produtos.length;
                    final estoqueBaixo = produtos.where((p) => p.estoqueBaixo).toList();
                    final totalCategorias = produtos.map((p) => p.categoria).toSet().length;
                    
                    final lucroTotal = produtos.fold<double>(
                      0, (total, p) => total + p.lucroTotalEstimado,
                    );

                    if (produtos.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.dashboard_outlined, size: 80, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Sem dados para exibir',
                              style: TextStyle(color: Colors.grey[500], fontSize: 18),
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          // 1. HERO CARD (Lucro)
                          FadeInAnimation(
                            delay: 0,
                            child: _HeroMoneyCard(valor: lucroTotal),
                          ),
                          
                          const SizedBox(height: 20),

                          // 2. MINI CARDS (Produtos e Categorias)
                          FadeInAnimation(
                            delay: 100,
                            child: Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    title: 'Produtos',
                                    value: totalProdutos.toString(),
                                    icon: Icons.inventory_2_rounded,
                                    color: const Color(0xFF2E86DE),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _StatCard(
                                    title: 'Categorias',
                                    value: totalCategorias.toString(),
                                    icon: Icons.category_rounded,
                                    color: const Color(0xFFFF9F43),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // 3. GRÁFICO
                          FadeInAnimation(
                            delay: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 4, bottom: 12),
                                  child: Text(
                                    'Análise de Estoque',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
                                  ),
                                ),
                                _buildChartCard(produtos),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Header Customizado (Igual EstoquePage) ---
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
        children: [
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
          ),
          const SizedBox(width: 20),
          const Text(
            'Visão Geral',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

          ValueListenableBuilder(
            valueListenable: produtoBox.listenable(),
            builder: (context, Box<Produto> box, _) {
              // Usa a mesma regra de estoque baixo que você já tinha criado
              final alertas = box.values.where((p) => p.estoqueBaixo).toList();
              final temAlerta = alertas.isNotEmpty;

              return GestureDetector(
                onTap: () => _mostrarAlertas(context, alertas), // Abre a lista
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Badge(
                    isLabelVisible: temAlerta,
                    label: Text('${alertas.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.redAccent,
                    child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                );
  },
                ),
                ],
              ),
    );
  }

  // Extraí o Card do Gráfico para limpar o build
  // Extraí o Card do Gráfico para limpar o build
  Widget _buildChartCard(List<Produto> produtos) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.pie_chart_rounded, color: Colors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "Distribuição por Quantidade",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: produtos.isEmpty
                ? const Center(child: Text("Sem dados"))
                : Row(
                    children: [
                      // --- O GRÁFICO ---
                      Expanded(
                        flex: 3,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 1.0, // 👇 Diminuímos as linhas brancas aqui
                            centerSpaceRadius: 40,
                            sections: produtos.take(5).map((p) {
                              final index = produtos.indexOf(p);
                              final List<Color> cores = [
                                Colors.blue, Colors.purple, Colors.orange, Colors.teal, Colors.red
                              ];
                              final color = cores[index % cores.length];

                              return PieChartSectionData(
                                color: color,
                                value: p.quantidade.toDouble(),
                                showTitle: false, // 👇 Tiramos o número de cima da cor aqui
                                radius: 45,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      
                      // --- A SUA LEGENDA (Manteve igual) ---
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: produtos.take(5).map((p) {
                            final index = produtos.indexOf(p);
                            final List<Color> cores = [
                              Colors.blue, Colors.purple, Colors.orange, Colors.teal, Colors.red
                            ];
                            final color = cores[index % cores.length];

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      p.nome,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
// --- Aba inferior de Alertas ---
  void _mostrarAlertas(BuildContext context, List<Produto> alertas) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta ao tamanho do conteúdo
            children: [
              // Linha cinza de puxar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Alertas de Estoque',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (alertas.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
                      SizedBox(height: 16),
                      Text(
                        'Tudo sob controle!\nNenhum produto com estoque baixo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: alertas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final p = alertas[index];
                      // Podemos reaproveitar o seu Widget _AlertItemTile!
                      return _AlertItemTile(produto: p);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

// ==========================================
// 🎨 WIDGETS ESTILIZADOS
// ==========================================

class _HeroMoneyCard extends StatelessWidget {
  final double valor;

  const _HeroMoneyCard({required this.valor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)], 
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4facfe).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.monetization_on_outlined, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text("Lucro Potencial", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.trending_up, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'R\$ ${valor.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }
}

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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Text(
            title,
            style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _AlertItemTile extends StatelessWidget {
  final Produto produto;

  const _AlertItemTile({required this.produto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child:GestureDetector(
        onTap:(){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EstoquePage()),
          );
         },
         child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.warning_rounded, color: Colors.redAccent, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "Resta apenas ${produto.quantidade}",
                  style: TextStyle(color: Colors.red[400], fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text("Repor", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    ),
    );
  }
}

// Widget de Animação (Para garantir que funcione sem imports extras)
class FadeInAnimation extends StatelessWidget {
  final int delay;
  final Widget child;

  const FadeInAnimation({super.key, required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: FutureBuilder(
        future: Future.delayed(Duration(milliseconds: delay)),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? child
              : const SizedBox.shrink(); // Espaço vazio enquanto espera o delay
        },
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