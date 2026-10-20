import 'package:flutter/material.dart';

import 'package:sigpe/contents/app_search.dart';
import 'package:sigpe/contents/bottom_nav.dart';
import 'package:sigpe/contents/professor_card.dart';
import 'package:sigpe/service/service.dart';
import 'package:sigpe/views/perfil_professores.dart';
import 'package:sigpe/views/cadastro_professor.dart';
import 'package:sigpe/views/dashboard.dart';
import 'package:sigpe/views/bens_page.dart';

class ProfessoresPage extends StatefulWidget {
  const ProfessoresPage({super.key});

  @override
  State<ProfessoresPage> createState() => _ProfessoresPageState();
}

class _ProfessoresPageState extends State<ProfessoresPage> {
  int _currentIndex = 2;
  String _busca = '';

  final AuthService _authService = AuthService();

  List<Map<String, dynamic>> professores = [];

  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarProfessores();
  }

  Future<void> _carregarProfessores() async {
    if (mounted) {
      setState(() {
        _carregando = true;
        _erro = null;
      });
    }

    try {
      final resultado = await _authService.getProfessores();

      if (!mounted) return;

      setState(() {
        professores = resultado;
        _carregando = false;
      });
    } on AuthException catch (error) {
      if (!mounted) return;

      setState(() {
        _erro = error.message;
        _carregando = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _erro = 'Não foi possível carregar os professores.';
        _carregando = false;
      });
    }
  }

  Future<void> _abrirCadastro() async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CadastroProfessorPage()),
    );

    if (!mounted) return;

    if (resultado == true) {
      await _carregarProfessores();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = professores.where((professor) {
      final nome = (professor['nome'] ?? '').toString().toLowerCase();

      return nome.contains(_busca.trim().toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE7),

      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Dashboard(),
                        ),
                      );
                    },
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

            // BUSCA
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

            // BOTÃO CADASTRAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _abrirCadastro,
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Cadastrar professor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A3824),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // LISTA
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : _erro != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_erro!, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: _carregarProfessores,
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : filtrados.isEmpty
                  ? Center(
                      child: Text(
                        _busca.isEmpty
                            ? 'Nenhum professor encontrado.'
                            : 'Nenhum resultado para "$_busca".',
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _carregarProfessores,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filtrados.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final professor = filtrados[index];

                          return InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              final id = professor['id'];

                              if (id is! int) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ID do professor inválido.'),
                                  ),
                                );
                                return;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PerfilProfessoresPage(professorId: id),
                                ),
                              );
                            },
                            child: ProfessorCard(
                              nome: professor['nome']?.toString() ?? '',
                              disciplina:
                                  professor['departamento']?.toString() ?? '',
                              matricula:
                                  professor['matricula']?.toString() ?? '',
                              quantidadeBens:
                                  professor['totalPatrimonios'] is int
                                  ? professor['totalPatrimonios'] as int
                                  : 0,
                            ),
                          );
                        },
                      ),
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
}
