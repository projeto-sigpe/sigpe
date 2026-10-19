import 'package:flutter/material.dart';
import 'package:sigpe/contents/app_search.dart';
import 'package:sigpe/contents/bottom_nav.dart';
import 'package:sigpe/contents/professor_card.dart';
import 'package:sigpe/service/service.dart';
import 'package:sigpe/views/perfil_professores.dart';

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
    try {
      final resultado = await _authService.getProfessores();
      if (!mounted) return;
      setState(() {
        professores = resultado;
        _erro = null;
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
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : _erro != null
                  ? Center(child: Text(_erro!))
                  : filtrados.isEmpty
                  ? const Center(child: Text('Nenhum professor encontrado.'))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: filtrados.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final professor = filtrados[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PerfilProfessoresPage(
                                  professorId: professor['id'] as int,
                                ),
                              ),
                            );
                          },
                          child: ProfessorCard(
                            nome: professor['nome'],
                            disciplina:
                                professor['departamento']?.toString() ?? '',
                            matricula: professor['matricula']?.toString() ?? '',
                            quantidadeBens:
                                professor['totalPatrimonios'] as int? ?? 0,
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
