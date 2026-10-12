import 'package:flutter/material.dart';

import '../contents/bottom_nav.dart';
import '../contents/section_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  static const Color marrom = Color(0xFF4A2E1F);
  static const Color fundo = Color(0xFFF5EFE7);
  static const Color bege = Color(0xFFE9DED2);

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
                    const Text(
                      'Olá, Ana Souza!',
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
          setState(() {
            _currentIndex = index;
          });
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
                Text(
                  'Olá, Ana Souza!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          const Icon(Icons.notifications_none, color: Colors.white, size: 27),

          const SizedBox(width: 12),

          const CircleAvatar(
            backgroundColor: bege,
            child: Icon(Icons.person, color: marrom),
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
              const Expanded(
                child: Text(
                  '1.482',
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
            child: const LinearProgressIndicator(
              value: 0.86,
              minHeight: 7,
              backgroundColor: Color(0xFF8C7B6C),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFBCA38C)),
            ),
          ),

          const SizedBox(height: 16),

          const Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _Legenda(cor: Color(0xFFD2B89F), texto: '684 Disponíveis'),
              _Legenda(cor: Color(0xFFA8B3A1), texto: '512 Em uso'),
              _Legenda(cor: Color(0xFFC58B63), texto: '286 Manutenção'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumo() {
    return const Row(
      children: [
        Expanded(
          child: _ResumoCard(titulo: 'Disponível', quantidade: '415'),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _ResumoCard(titulo: 'Em uso', quantidade: '984'),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _ResumoCard(titulo: 'Manutenção', quantidade: '83'),
        ),
      ],
    );
  }

  Widget _buildCategorias() {
    final categorias = [
      _Categoria('Informática', 0.35, '35%', Color(0xFF827E75)),
      _Categoria('Mobiliário', 0.26, '26%', Color(0xFFB3A18F)),
      _Categoria('Laboratório', 0.20, '20%', Color(0xFF4A2E1F)),
      _Categoria('Audiovisual', 0.12, '12%', Color(0xFFD1B69D)),
      _Categoria('Outros', 0.07, '7%', Color(0xFF6B5140)),
    ];

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
