import 'package:flutter/material.dart';
import 'package:sigpe/contents/bottom_nav.dart';
import 'package:sigpe/contents/patrimonio_card.dart';
import 'package:sigpe/service/service.dart';
import 'package:sigpe/views/dashboard.dart';
import 'package:sigpe/views/bens_page.dart';

class PerfilProfessoresPage extends StatefulWidget {
  final int professorId;

  const PerfilProfessoresPage({super.key, required this.professorId});

  @override
  State<PerfilProfessoresPage> createState() => _PerfilProfessoresPageState();
}

class _PerfilProfessoresPageState extends State<PerfilProfessoresPage> {
  int _currentIndex = 2;
  final AuthService _authService = AuthService();
  Map<String, dynamic>? professor;
  List<Map<String, dynamic>> patrimonios = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    try {
      final resultado = await _authService.getProfessorDetails(
        widget.professorId,
      );
      if (!mounted) return;
      setState(() {
        professor = resultado['professor'] as Map<String, dynamic>;
        patrimonios = (resultado['patrimonios'] as List)
            .whereType<Map<String, dynamic>>()
            .toList();
        _carregando = false;
      });
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _erro = error.message;
        _carregando = false;
      });
    }
  }

  String get dataCadastro {
    final data = DateTime.tryParse(professor?['createdAt']?.toString() ?? '');
    if (data == null) return '-';

    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF4A2E1F),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Perfil do Professor',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B2417),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : _erro != null
                  ? Center(child: Text(_erro!))
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        // Cartão principal do professor
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE8DED3)),
                          ),
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 42,
                                backgroundColor: Color(0xFFE9DED2),
                                child: Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Color(0xFF5A3824),
                                ),
                              ),
                              const SizedBox(height: 12),

                              Text(
                                professor!['nome']?.toString() ?? '-',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3B2417),
                                ),
                              ),
                              const SizedBox(height: 5),

                              Text(
                                'Professor',
                                style: TextStyle(
                                  color: Colors.brown.shade400,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Divider(),

                              _informacao(
                                'ID',
                                professor!['id']?.toString() ?? '-',
                                Icons.numbers,
                              ),
                              _informacao(
                                'Matrícula',
                                professor!['matricula']?.toString() ?? '-',
                                Icons.badge_outlined,
                              ),
                              _informacao(
                                'E-mail',
                                professor!['email']?.toString() ?? '-',
                                Icons.email_outlined,
                              ),
                              _informacao(
                                'Telefone',
                                professor!['telefone']?.toString() ?? '-',
                                Icons.phone_outlined,
                              ),
                              _informacao(
                                'CPF',
                                professor!['cpf']?.toString() ?? '-',
                                Icons.assignment_ind_outlined,
                              ),
                              _informacao(
                                'Departamento',
                                professor!['departamento']?.toString() ?? '-',
                                Icons.menu_book_outlined,
                              ),
                              _informacao(
                                'Perfil de acesso',
                                'Professor',
                                Icons.manage_accounts_outlined,
                              ),
                              _informacao(
                                'Data de cadastro',
                                dataCadastro,
                                Icons.calendar_today_outlined,
                              ),
                              _informacao(
                                'Patrimônios vinculados',
                                professor!['totalPatrimonios']?.toString() ??
                                    '0',
                                Icons.inventory_2_outlined,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          'Patrimônios vinculados',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B2417),
                          ),
                        ),

                        const SizedBox(height: 12),

                        ...patrimonios.map((patrimonio) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: PatrimonioCard(
                              nome: patrimonio['nome']?.toString() ?? '-',
                              tombo: patrimonio['codigo']?.toString() ?? '-',
                              categoria:
                                  patrimonio['categoria']?.toString() ?? '-',
                              local:
                                  patrimonio['localizacao']?.toString() ?? '-',
                              status: patrimonio['status']?.toString() ?? '-',
                            ),
                          );
                        }),

                        const SizedBox(height: 12),
                      ],
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BensPage()),
            );
          } else if (index == 2) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _informacao(String titulo, String valor, IconData icone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: const Color(0xFF80634E), size: 22),
          const SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: Text(
              titulo,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Text(
              valor,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3B2417),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
