import 'package:flutter/material.dart';
import 'package:sigpe/contents/professor_bottom_nav.dart';
import 'package:sigpe/views/dashboard_professor.dart';
import 'package:sigpe/views/detalhes_bens_professor.dart';
import 'package:sigpe/views/perfil_professor_page.dart';

class BensProfessorPage extends StatefulWidget {
  const BensProfessorPage({super.key});

  @override
  State<BensProfessorPage> createState() => _BensProfessorPageState();
}

class _BensProfessorPageState extends State<BensProfessorPage> {
  static const Color marrom = Color(0xFF4A2E1F);
  static const Color fundo = Color(0xFFF7F2EB);
  static const Color texto = Color(0xFF6F6257);
  static const Color bege = Color(0xFFE9DED2);

  final TextEditingController buscaController = TextEditingController();

  String busca = '';

  final List<Map<String, String>> bens = [
    {
      'nome': 'Notebook Dell',
      'tombo': '0001',
      'local': 'Sala 12 - Bloco A',
      'data': '10/04/2025',
      'status': 'Em uso',
      'icone': 'notebook',
      'categoria': 'Informática',
      'marca': 'Dell',
      'serie': 'DELL-NT-001',
      'responsavel': 'Prof. Carlos Drummond',
    },
    {
      'nome': 'Projetor Epson',
      'tombo': '0007',
      'local': 'Laboratório',
      'data': '13/04/2025',
      'status': 'Em uso',
      'icone': 'projetor',
      'categoria': 'Equipamento audiovisual',
      'marca': 'Epson',
      'serie': 'EPS-PJ-007',
      'responsavel': 'Prof. Carlos Drummond',
    },
    {
      'nome': 'Tablet Samsung',
      'tombo': '0012',
      'local': 'Sala 08 - Bloco B',
      'data': '20/04/2025',
      'status': 'Em uso',
      'icone': 'tablet',
      'categoria': 'Informática',
      'marca': 'Samsung',
      'serie': 'SAM-TB-012',
      'responsavel': 'Prof. Carlos Drummond',
    },
  ];

  List<Map<String, String>> get bensFiltrados {
    final termo = busca.toLowerCase().trim();

    if (termo.isEmpty) return bens;

    return bens.where((bem) {
      return (bem['nome'] ?? '').toLowerCase().contains(termo) ||
          (bem['tombo'] ?? '').toLowerCase().contains(termo) ||
          (bem['local'] ?? '').toLowerCase().contains(termo);
    }).toList();
  }

  @override
  void dispose() {
    buscaController.dispose();
    super.dispose();
  }

  void _abrirDetalhes(Map<String, String> bem) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalhesBemProfessorPage(bem: bem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DashboardProfessorPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: marrom,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Text(
                    'Meus Bens',
                    style: TextStyle(
                      color: marrom,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Busca
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                controller: buscaController,
                onChanged: (valor) {
                  setState(() {
                    busca = valor;
                  });
                },
                style: const TextStyle(fontSize: 13, color: marrom),
                decoration: InputDecoration(
                  hintText: 'Buscar bem...',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.black38,
                  ),
                  prefixIcon: const Icon(Icons.search, size: 20, color: texto),
                  suffixIcon: busca.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            buscaController.clear();
                            setState(() {
                              busca = '';
                            });
                          },
                          icon: const Icon(Icons.close, size: 18),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.85),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: bege),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: bege),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: marrom),
                  ),
                ),
              ),
            ),

            // Lista de bens
            Expanded(
              child: bensFiltrados.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum bem encontrado.',
                        style: TextStyle(color: texto, fontSize: 13),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      itemCount: bensFiltrados.length,
                      itemBuilder: (context, index) {
                        return _cartaoBem(bensFiltrados[index]);
                      },
                    ),
            ),
          ],
        ),
      ),

      // Navbar exclusiva do professor
      bottomNavigationBar: ProfessorBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardProfessorPage()),
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

  Widget _cartaoBem(Map<String, String> bem) {
    return InkWell(
      onTap: () => _abrirDetalhes(bem),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.65),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEDE4D9), width: 0.7),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícone do patrimônio
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bege,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_iconeBem(bem['icone']), color: marrom, size: 30),
            ),

            const SizedBox(width: 10),

            // Informações do bem
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bem['nome'] ?? 'Equipamento',
                    style: const TextStyle(
                      color: marrom,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Tombamento: ${bem['tombo'] ?? 'Não informado'}',
                    style: const TextStyle(color: texto, fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bem['local'] ?? 'Local não informado',
                    style: const TextStyle(color: texto, fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Atribuído em: ${bem['data'] ?? 'Não informado'}',
                    style: const TextStyle(color: texto, fontSize: 9),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 5),

            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: marrom,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                bem['status'] ?? 'Indefinido',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconeBem(String? tipo) {
    switch (tipo) {
      case 'notebook':
        return Icons.laptop_chromebook;
      case 'projetor':
        return Icons.connected_tv;
      case 'tablet':
        return Icons.tablet_android;
      default:
        return Icons.inventory_2_outlined;
    }
  }
}
