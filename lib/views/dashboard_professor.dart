import 'package:flutter/material.dart';
import 'package:sigpe/contents/professor_bottom_nav.dart';
import 'package:sigpe/views/bens_professor.dart';
import 'package:sigpe/views/perfil_professor_page.dart';
import 'package:sigpe/service/service.dart';
import 'package:sigpe/views/login_page.dart';

class DashboardProfessorPage extends StatefulWidget {
  const DashboardProfessorPage({super.key});

  @override
  State<DashboardProfessorPage> createState() => _DashboardProfessorPageState();
}

class _DashboardProfessorPageState extends State<DashboardProfessorPage> {
  static const Color marrom = Color(0xFF4A2E1F);
  static const Color fundo = Color(0xFFF5EFE7);
  static const Color bege = Color(0xFFE9DED2);

  int _currentIndex = 0;

  /// Método responsável por realizar o Logout seguro
  Future<void> fazerLogout() async {
    try {
      await AuthService().logout();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
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
            // Imagem de fundo
            Positioned.fill(
              child: Image.asset(
                'assets/fundo_professor.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: fundo);
                },
              ),
            ),

            // Camada clara para facilitar a leitura
            Positioned.fill(
              // ignore: deprecated_member_use
              child: Container(color: fundo.withOpacity(0.18)),
            ),

            // Conteúdo Principal
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabeçalho
                    Row(
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
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SIGPE',
                                style: TextStyle(
                                  color: marrom,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Professor (Docente)',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Você não tem novas notificações.',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications_none,
                            color: marrom,
                          ),
                        ),
                        const CircleAvatar(
                          radius: 21,
                          backgroundColor: bege,
                          child: Icon(Icons.person, color: marrom),
                        ),
                        const SizedBox(width: 4),
                        // Botão de Logout adicionado no cabeçalho
                        IconButton(
                          tooltip: 'Sair da conta',
                          onPressed: fazerLogout,
                          icon: const Icon(
                            Icons.logout,
                            color: marrom,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 27),

                    const Text(
                      'Olá, Mariana!',
                      style: TextStyle(
                        color: marrom,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Professora de Matemática',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),

                    const SizedBox(height: 22),

                    // Boas-vindas
                    Container(
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
                                  'Aqui você encontra os bens que estão sob sua responsabilidade.',
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
                    ),

                    const SizedBox(height: 18),

                    // Meus bens
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: marrom.withOpacity(0.94),
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
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MEUS BENS',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  '3 bens atribuídos',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
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
                                  builder: (context) =>
                                      const BensProfessorPage(),
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
                    ),

                    const SizedBox(height: 18),

                    // Resumo dos bens
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 17,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.90),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: _Resumo(
                              icone: Icons.laptop_outlined,
                              quantidade: '2',
                              titulo: 'Em uso',
                            ),
                          ),
                          Expanded(
                            child: _Resumo(
                              icone: Icons.build_outlined,
                              quantidade: '1',
                              titulo: 'Manutenção',
                            ),
                          ),
                          Expanded(
                            child: _Resumo(
                              icone: Icons.assignment_return_outlined,
                              quantidade: '0',
                              titulo: 'Devolvidos',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Categorias
                    Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.90),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categorias de Bens',
                            style: TextStyle(
                              color: marrom,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: _Categoria(
                                  icone: Icons.laptop_outlined,
                                  titulo: 'Informática',
                                ),
                              ),
                              Expanded(
                                child: _Categoria(
                                  icone: Icons.videocam_outlined,
                                  titulo: 'Projetores',
                                ),
                              ),
                              Expanded(
                                child: _Categoria(
                                  icone: Icons.tablet_android_outlined,
                                  titulo: 'Tablets',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
              MaterialPageRoute(builder: (_) => const BensProfessorPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PerfilProfessorPage()),
            );
          }
        },
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
        Icon(icone, color: const Color(0xFF6A4A35), size: 25),
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
          style: const TextStyle(color: Colors.black54, fontSize: 10),
        ),
      ],
    );
  }
}

class _Categoria extends StatelessWidget {
  final IconData icone;
  final String titulo;

  const _Categoria({required this.icone, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFF0E5D9),
          child: Icon(icone, color: const Color(0xFF4A2E1F)),
        ),
        const SizedBox(height: 8),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF4A2E1F), fontSize: 10),
        ),
      ],
    );
  }
}