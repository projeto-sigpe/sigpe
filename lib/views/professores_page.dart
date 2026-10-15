import 'package:flutter/material.dart';
import 'package:sigpe/contents/app_search.dart';
import 'package:sigpe/contents/bottom_nav.dart';
import 'package:sigpe/contents/professor_card.dart';
import 'package:sigpe/views/perfil_professores.dart';

class ProfessoresPage extends StatefulWidget {
  const ProfessoresPage({super.key});

  @override
  State<ProfessoresPage> createState() => _ProfessoresPageState();
}

class _ProfessoresPageState extends State<ProfessoresPage> {
  int _currentIndex = 2;
  String _busca = '';

  final List<Map<String, dynamic>> professores = [
    {
      'nome': 'Ana Souza',
      'disciplina': 'Matemática',
      'matricula': '2345',
      'quantidadeBens': 3,
    },
    {
      'nome': 'Carlos Oliveira',
      'disciplina': 'História',
      'matricula': '1987',
      'quantidadeBens': 2,
    },
    {
      'nome': 'Juliana Lima',
      'disciplina': 'Biologia',
      'matricula': '1765',
      'quantidadeBens': 5,
    },
    {
      'nome': 'Marcos Santos',
      'disciplina': 'Física',
      'matricula': '2034',
      'quantidadeBens': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtrados = professores.where((professor) {
      final nome = professor['nome'].toString().toLowerCase();
      return nome.contains(_busca.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
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
                      'Lista de Professores',
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppSearch(
                hintText: 'Buscar professor...',
                onChanged: (valor) {
                  setState(() => _busca = valor);
                },
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: filtrados.isEmpty
                  ? const Center(child: Text('Nenhum professor encontrado.'))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: filtrados.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final professor = filtrados[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PerfilProfessoresPage(),
                              ),
                            );
                          },
                          child: ProfessorCard(
                            nome: professor['nome'],
                            disciplina: professor['disciplina'],
                            matricula: professor['matricula'],
                            quantidadeBens: professor['quantidadeBens'],
                          ),
                        );
                      },
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
}
