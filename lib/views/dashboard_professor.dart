
import 'package:flutter/material.dart';
import 'package:sigpe/contents/professor_bottom_nav.dart';
import 'package:sigpe/views/bens_professor.dart';
import 'package:sigpe/views/perfil_professor_page.dart';
import 'package:sigpe/service/service.dart';
import 'package:sigpe/routes/app_routes.dart';

class DashboardProfessorPage extends StatefulWidget {
  const DashboardProfessorPage({super.key});

  @override
  State<DashboardProfessorPage> createState() =>
      _DashboardProfessorPageState();
}

class _DashboardProfessorPageState
    extends State<DashboardProfessorPage> {
  static const Color marrom = Color(0xFF4A2E1F);
  static const Color fundo = Color(0xFFF5EFE7);
  static const Color bege = Color(0xFFE9DED2);

  final AuthService _authService = AuthService();

  int _currentIndex = 0;
  bool _carregando = true;
  String? _erroPerfil;
  String? _erroPatrimonios;

  String _nomeProfessor = 'Professor';
  String _departamento = '';

  List<Map<String, dynamic>> _patrimonios = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  String _lerTexto(
    Map<String, dynamic> dados,
    List<String> chaves,
  ) {
    for (final chave in chaves) {
      final valor = dados[chave];

      if (valor != null && valor.toString().trim().isNotEmpty) {
        return valor.toString().trim();
      }
    }

    return '';
  }

  Future<void> _carregarDados() async {
    if (!mounted) return;

    setState(() {
      _carregando = true;
      _erroPerfil = null;
      _erroPatrimonios = null;
    });

    // O perfil e os patrimônios são carregados separadamente.
    try {
      debugPrint('SIGPE: carregando perfil');

      final perfil = await _authService.getProfile();

      Map<String, dynamic> usuario = perfil;

      for (final chave in [
        'user',
        'usuario',
        'professor',
        'profile',
      ]) {
        final valor = usuario[chave];

        if (valor is Map) {
          usuario = Map<String, dynamic>.from(valor);
          break;
        }
      }

      final nome = _lerTexto(usuario, [
        'nome',
        'name',
        'nome_completo',
        'nomeCompleto',
      ]);

      final departamento = _lerTexto(usuario, [
        'departamento',
        'disciplina',
        'materia',
      ]);

      if (!mounted) return;

      setState(() {
        _nomeProfessor =
            nome.isNotEmpty ? nome : 'Professor';
        _departamento = departamento;
      });

      debugPrint('SIGPE: professor $_nomeProfessor');
    } catch (e, stackTrace) {
      debugPrint('SIGPE ERRO PERFIL: $e');
      debugPrint('$stackTrace');

      if (mounted) {
        setState(() {
          _erroPerfil = e.toString();
        });
      }
    }

    try {
      debugPrint('SIGPE: carregando patrimônios');

      // Consulta os bens usando o token do professor autenticado.
      final patrimonios = await _authService.getPatrimonios(
        meus: true,
      );

      debugPrint(
        'SIGPE: ${patrimonios.length} patrimônios recebidos',
      );

      if (!mounted) return;

      setState(() {
        _patrimonios = patrimonios;
      });
    } catch (e, stackTrace) {
      debugPrint('SIGPE ERRO PATRIMÔNIOS: $e');
      debugPrint('$stackTrace');

      if (mounted) {
        setState(() {
          _erroPatrimonios = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  String _normalizar(String texto) {
    return texto
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .trim();
  }

  String _status(Map<String, dynamic> bem) {
    return _normalizar(
      _lerTexto(bem, [
        'status',
        'situacao',
        'situação',
        'estado',
      ]),
    );
  }

  bool _statusContem(
    Map<String, dynamic> bem,
    List<String> termos,
  ) {
    final status = _status(bem);
    return termos.any((termo) => status.contains(termo));
  }

  int get _emUso => _patrimonios.where((bem) {
        return _statusContem(
          bem,
          ['em uso', 'utilizado'],
        );
      }).length;

  int get _emManutencao => _patrimonios.where((bem) {
        return _statusContem(
          bem,
          ['manuten', 'reparo'],
        );
      }).length;

  int get _devolvidos => _patrimonios.where((bem) {
        return _statusContem(
          bem,
          ['devolvido', 'devolvida'],
        );
      }).length;

  List<String> get _categorias {
    final categorias = _patrimonios
        .map(
          (bem) => _lerTexto(bem, [
            'categoria',
            'tipo',
            'nome_categoria',
            'nomeCategoria',
          ]),
        )
        .where((categoria) => categoria.isNotEmpty)
        .toSet()
        .toList();

    categorias.sort();
    return categorias;
  }

  IconData _iconeCategoria(String categoria) {
    final texto = _normalizar(categoria);

    if (texto.contains('informatica') ||
        texto.contains('computador') ||
        texto.contains('notebook')) {
      return Icons.laptop_outlined;
    }

    if (texto.contains('projetor')) {
      return Icons.videocam_outlined;
    }

    if (texto.contains('tablet')) {
      return Icons.tablet_android_outlined;
    }

    if (texto.contains('movel') ||
        texto.contains('mesa') ||
        texto.contains('cadeira')) {
      return Icons.chair_outlined;
    }

    return Icons.inventory_2_outlined;
  }

  Future<void> fazerLogout() async {
    try {
      await _authService.logout();

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao sair da conta: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/fundo_professor.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: fundo);
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                color: fundo.withOpacity(0.18),
              ),
            ),
            RefreshIndicator(
              onRefresh: _carregarDados,
              color: marrom,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _cabecalho(),
                    const SizedBox(height: 24),

                    if (_carregando)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(
                            color: marrom,
                          ),
                        ),
                      )
                    else ...[
                      Text(
                        'Olá, $_nomeProfessor!',
                        style: const TextStyle(
                          color: marrom,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _departamento.isNotEmpty
                            ? 'Professor(a) de $_departamento'
                            : 'Professor(a)',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 22),

                      if (_erroPerfil != null)
                        _aviso(
                          'Não foi possível carregar o perfil.',
                          _erroPerfil!,
                        ),

                      _cartaoBoasVindas(),
                      const SizedBox(height: 18),
                      _cartaoMeusBens(),
                      const SizedBox(height: 18),
                      _cartaoResumo(),
                      const SizedBox(height: 18),

                      if (_erroPatrimonios != null)
                        _aviso(
                          'Não foi possível carregar seus bens.',
                          _erroPatrimonios!,
                        ),

                      _cartaoCategorias(),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProfessorBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            setState(() => _currentIndex = 0);
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const BensProfessorPage(),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const PerfilProfessorPage(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _aviso(String titulo, String detalhe) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: marrom,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            detalhe,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          TextButton.icon(
            onPressed: _carregarDados,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _cabecalho() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 23,
          backgroundColor: marrom,
          child: Icon(
            Icons.school_outlined,
            color: Colors.white,
            size: 27,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SIGPE',
                style: TextStyle(
                  color: marrom,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Professor (Docente)',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
              Text(
                _nomeProfessor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: marrom,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Notificações',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Você não tem novas notificações.'),
              ),
            );
          },
          icon: const Icon(
            Icons.notifications_none,
            color: marrom,
          ),
        ),
        CircleAvatar(
          radius: 21,
          backgroundColor: bege,
          child: Text(
            _nomeProfessor.isNotEmpty
                ? _nomeProfessor[0].toUpperCase()
                : 'P',
            style: const TextStyle(
              color: marrom,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Sair da conta',
          onPressed: fazerLogout,
          icon: const Icon(Icons.logout, color: marrom),
        ),
      ],
    );
  }

  Widget _cartaoBoasVindas() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: bege,
            child: Icon(
              Icons.menu_book_outlined,
              color: marrom,
              size: 27,
            ),
          ),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seja bem-vindo(a)!',
                  style: TextStyle(
                    color: marrom,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Confira os bens vinculados à sua conta e acompanhe sua situação.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartaoMeusBens() {
    final quantidade = _patrimonios.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: marrom.withOpacity(0.96),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MEUS BENS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '$quantidade ${quantidade == 1 ? 'bem atribuído' : 'bens atribuídos'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BensProfessorPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartaoResumo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Resumo(
              icone: Icons.laptop_outlined,
              quantidade: '$_emUso',
              titulo: 'Em uso',
            ),
          ),
          Expanded(
            child: _Resumo(
              icone: Icons.build_outlined,
              quantidade: '$_emManutencao',
              titulo: 'Manutenção',
            ),
          ),
          Expanded(
            child: _Resumo(
              icone: Icons.assignment_return_outlined,
              quantidade: '$_devolvidos',
              titulo: 'Devolvidos',
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartaoCategorias() {
    final categorias = _categorias;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categorias de Bens',
            style: TextStyle(
              color: marrom,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          if (categorias.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Nenhum bem atribuído ainda.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          else
            Wrap(
              alignment: WrapAlignment.spaceAround,
              runSpacing: 18,
              spacing: 12,
              children: categorias.map((categoria) {
                return SizedBox(
                  width: 85,
                  child: _Categoria(
                    icone: _iconeCategoria(categoria),
                    titulo: categoria,
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _Resumo extends StatelessWidget {
  final IconData icone;
  final String quantidade;
  final String titulo;

  const _Resumo({
    required this.icone,
    required this.quantidade,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icone,
          color: const Color(0xFF6A4A35),
          size: 25,
        ),
        const SizedBox(height: 8),
        Text(
          quantidade,
          style: const TextStyle(
            color: Color(0xFF4A2E1F),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _Categoria extends StatelessWidget {
  final IconData icone;
  final String titulo;

  const _Categoria({
    required this.icone,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFF0E5D9),
          child: Icon(
            icone,
            color: const Color(0xFF4A2E1F),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF4A2E1F),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
