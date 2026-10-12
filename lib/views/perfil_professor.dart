import 'package:flutter/material.dart';
import 'package:sigpe/contents/bottom_nav.dart';
import 'package:sigpe/contents/patrimonio_card.dart';

class PerfilProfessorPage extends StatefulWidget {
  const PerfilProfessorPage({super.key});

  @override
  State<PerfilProfessorPage> createState() => _PerfilProfessorPageState();
}

class _PerfilProfessorPageState extends State<PerfilProfessorPage> {
  int _currentIndex = 2;

  // Dados fictícios baseados no JSON fornecido
  final Map<String, dynamic> professor = {
    'id': 2,
    'nome': 'Prof. Carlos Drummond',
    'email': 'professor@escola.com',
    'matricula': 'PROF-2024-01',
    'departamento': 'Língua Portuguesa e Literatura',
    'telefone': '(11) 98765-1001',
    'cpf': '123.456.789-00',
    'role': 'professor',
    'totalPatrimonios': 3,
    'createdAt': '2026-09-14T19:33:00Z',
  };

  final List<Map<String, String>> patrimonios = [
    {
      'nome': 'Notebook Dell',
      'tombo': 'PAT-001',
      'categoria': 'Informática',
      'local': 'Sala dos professores',
      'status': 'Em uso',
    },
    {
      'nome': 'Projetor Epson',
      'tombo': 'PAT-014',
      'categoria': 'Audiovisual',
      'local': 'Sala 12',
      'status': 'Disponível',
    },
    {
      'nome': 'Monitor LG',
      'tombo': 'PAT-023',
      'categoria': 'Informática',
      'local': 'Laboratório',
      'status': 'Em uso',
    },
  ];

  String get dataCadastro {
    final data = DateTime.parse(professor['createdAt']).toLocal();

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
              child: ListView(
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
                          professor['nome'],
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
                          professor['id'].toString(),
                          Icons.numbers,
                        ),
                        _informacao(
                          'Matrícula',
                          professor['matricula'],
                          Icons.badge_outlined,
                        ),
                        _informacao(
                          'E-mail',
                          professor['email'],
                          Icons.email_outlined,
                        ),
                        _informacao(
                          'Telefone',
                          professor['telefone'],
                          Icons.phone_outlined,
                        ),
                        _informacao(
                          'CPF',
                          professor['cpf'],
                          Icons.assignment_ind_outlined,
                        ),
                        _informacao(
                          'Departamento',
                          professor['departamento'],
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
                          professor['totalPatrimonios'].toString(),
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
                        nome: patrimonio['nome']!,
                        tombo: patrimonio['tombo']!,
                        categoria: patrimonio['categoria']!,
                        local: patrimonio['local']!,
                        status: patrimonio['status']!,
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
          setState(() => _currentIndex = index);
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
