import 'package:flutter/material.dart';
import 'package:sigpe/views/bens_page.dart';
import 'package:sigpe/views/professores_page.dart';
import 'package:sigpe/routes/app_routes.dart';
import '../service/service.dart';

import '../contents/bottom_nav.dart';
import '../contents/section_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _carregarStats();
  }

  Future<void> _carregarStats() async {
    try {
      final stats = await _authService.getPatrimonioStats();

      if (mounted) {
        setState(() {
          _stats = stats;
        });
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }

  String _stat(String key, [String fallback = '0']) =>
      _stats[key]?.toString() ?? fallback;

  static const Color marrom = Color(0xFF4A2E1F);
  static const Color fundo = Color(0xFFF5EFE7);
  // ignore: unused_field
  static const Color bege = Color(0xFFE9DED2);

  /// Função responsável por realizar o Logout seguro conforme o requisito:
  /// 1. Remove os tokens JWT do dispositivo
  /// 2. Encerra a sessão
  /// 3. Redireciona para a tela de Login limpando a pilha de navegação
  Future<void> _fazerLogout() async {
    final authService = AuthService();
    await authService.logout();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, ${_stats['nome'] ?? 'Administrador'}!',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: marrom,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildPatrimonioGeral(),

                    const SizedBox(height: 16),

                    _buildResumo(),

                    const SizedBox(height: 18),

                    SectionCard(
                      titulo: 'Categorias de Bens',
                      child: _buildCategorias(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BensPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfessoresPage()),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
      decoration: const BoxDecoration(
        color: marrom,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.home_work_outlined,
              color: Colors.white,
              size: 29,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIGPE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
              ],
            ),
          ),

          const Icon(Icons.notifications_none, color: Colors.white, size: 27),

          const SizedBox(width: 8),

          // Botão de Logout adicionado no cabeçalho
          IconButton(
            tooltip: 'Sair da conta',
            icon: const Icon(Icons.logout, color: Colors.white, size: 25),
            onPressed: _fazerLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildPatrimonioGeral() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: marrom,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PATRIMÔNIO GERAL TOMBADO',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Text(
                  _stat('total', _stat('totalPatrimonios')),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF725541),
                  foregroundColor: Colors.white,
                ),
                child: const Text('+ Ver mais'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: () {
                final total = num.tryParse(_stat('totalPatrimonios')) ?? 0;
                final disponiveis =
                    num.tryParse(_stat('patrimoniosDisponiveis')) ?? 0;

                return total > 0
                    ? (disponiveis / total).clamp(0.0, 1.0).toDouble()
                    : 0.0;
              }(),
              minHeight: 7,
              backgroundColor: const Color(0xFF8C7B6C),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFBCA38C),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _Legenda(
                cor: const Color(0xFFD2B89F),
                texto: '${_stat('patrimoniosDisponiveis')} Disponíveis',
              ),
              _Legenda(
                cor: const Color(0xFFA8B3A1),
                texto: '${_stat('patrimoniosEmUso')} Em uso',
              ),
              _Legenda(
                cor: const Color(0xFFC58B63),
                texto: '${_stat('patrimoniosEmManutencao')} Manutenção',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumo() {
    return Row(
      children: [
        Expanded(
          child: _ResumoCard(
            titulo: 'Disponível',
            quantidade: _stat('patrimoniosDisponiveis'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ResumoCard(
            titulo: 'Em uso',
            quantidade: _stat('patrimoniosEmUso'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ResumoCard(
            titulo: 'Manutenção',
            quantidade: _stat('patrimoniosEmManutencao'),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorias() {
    final Map<String, dynamic> dadosCategoria = Map<String, dynamic>.from(
      _stats['porCategoria'] ?? {},
    );

    final int total = dadosCategoria.values.fold<int>(
      0,
      (soma, quantidade) => soma + (quantidade as num).toInt(),
    );

    final cores = [
      const Color(0xFF827E75),
      const Color(0xFFB3A18F),
      const Color(0xFF4A2E1F),
      const Color(0xFFD1B69D),
      const Color(0xFF6B5140),
    ];

    final categorias = dadosCategoria.entries.toList().asMap().entries.map((
      item,
    ) {
      final categoria = item.value;
      final quantidade = (categoria.value as num).toInt();
      final percentual = total > 0 ? quantidade / total : 0.0;

      return _Categoria(
        categoria.key,
        percentual,
        '${(percentual * 100).round()}%',
        cores[item.key % cores.length],
      );
    }).toList();

    // Mantenha abaixo o restante do método atual,
    // que desenha o gráfico e a legenda.

    return Column(
      children: [
        SizedBox(
          height: 190,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child: SizedBox(
                    width: 145,
                    height: 145,
                    child: CustomPaint(
                      painter: _GraficoRosca(categorias),
                      child: const Center(
                        child: CircleAvatar(
                          radius: 31,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: categorias.map((categoria) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: categoria.cor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              categoria.nome,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                          Text(
                            categoria.porcentagem,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
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
    );
  }
}

class _ResumoCard extends StatelessWidget {
  final String titulo;
  final String quantidade;

  const _ResumoCard({required this.titulo, required this.quantidade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE8DED3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 7),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              quantidade,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3B2417),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legenda extends StatelessWidget {
  final Color cor;
  final String texto;

  const _Legenda({required this.cor, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 9, color: cor),
        const SizedBox(width: 5),
        Text(texto, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}

class _Categoria {
  final String nome;
  final double valor;
  final String porcentagem;
  final Color cor;

  const _Categoria(this.nome, this.valor, this.porcentagem, this.cor);
}

class _GraficoRosca extends CustomPainter {
  final List<_Categoria> categorias;

  _GraficoRosca(this.categorias);

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final retangulo = Rect.fromCircle(center: centro, radius: size.width / 2);

    final pincel = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 32
      ..strokeCap = StrokeCap.butt;

    double inicio = -1.5708;

    for (final categoria in categorias) {
      pincel.color = categoria.cor;

      final angulo = categoria.valor * 6.283185;

      canvas.drawArc(retangulo, inicio, angulo, false, pincel);

      inicio += angulo;
    }
  }

  @override
  bool shouldRepaint(covariant _GraficoRosca oldDelegate) {
    return oldDelegate.categorias != categorias;
  }
}
