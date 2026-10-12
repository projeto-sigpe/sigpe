import 'package:flutter/material.dart';
import 'package:sigpe/contents/bottom_nav.dart';
import 'package:sigpe/contents/patrimonio_card.dart';
import 'package:sigpe/views/cadastrar_bens.dart';

class BensPage extends StatefulWidget {
  const BensPage({super.key});

  @override
  State<BensPage> createState() => _BensPageState();
}

class _BensPageState extends State<BensPage> {
  int _currentIndex = 1;

  String _busca = '';
  String _statusSelecionado = 'Todos';
  String _categoriaSelecionada = 'Todas as categorias';

  final List<Map<String, String>> _bens = [
    {
      'nome': 'Notebook Dell',
      'tombo': '0001',
      'categoria': 'Informática',
      'local': 'Sala dos professores',
      'status': 'Em uso',
      'marca': 'Dell',
      'serie': 'SN123456',
    },
    {
      'nome': 'Projetor Epson',
      'tombo': '0007',
      'categoria': 'Audiovisual',
      'local': 'Laboratório',
      'status': 'Disponível',
      'marca': 'Epson',
      'serie': 'EP789123',
    },
    {
      'nome': 'Tablet Ergonômico',
      'tombo': '0009',
      'categoria': 'Mobiliário',
      'local': 'Sala 03',
      'status': 'Manutenção',
      'marca': 'Samsung',
      'serie': 'SM456789',
    },
  ];

  final List<String> _categorias = [
    'Todas as categorias',
    'Informática',
    'Audiovisual',
    'Mobiliário',
  ];

  List<Map<String, String>> get _bensFiltrados {
    return _bens.where((bem) {
      final nome = bem['nome']!.toLowerCase();
      final tombo = bem['tombo']!.toLowerCase();
      final categoria = bem['categoria']!;

      final correspondeBusca =
          nome.contains(_busca.toLowerCase()) ||
          tombo.contains(_busca.toLowerCase()) ||
          categoria.toLowerCase().contains(_busca.toLowerCase());

      final correspondeStatus =
          _statusSelecionado == 'Todos' || bem['status'] == _statusSelecionado;

      final correspondeCategoria =
          _categoriaSelecionada == 'Todas as categorias' ||
          categoria == _categoriaSelecionada;

      return correspondeBusca && correspondeStatus && correspondeCategoria;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final total = _bens.length;
    final emUso = _bens.where((b) => b['status'] == 'Em uso').length;
    final disponiveis = _bens.where((b) => b['status'] == 'Disponível').length;
    final manutencao = _bens.where((b) => b['status'] == 'Manutenção').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE7),
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
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
                      'Lista de Bens',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B2417),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Cadastrar bem',
                    onPressed: () async {
                      final novoBem = await Navigator.push<Map<String, String>>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CadastrarBensPage(),
                        ),
                      );

                      if (novoBem != null && mounted) {
                        setState(() {
                          _bens.add(novoBem);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bem cadastrado com sucesso!'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF5A3824),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Busca
                  TextField(
                    onChanged: (valor) {
                      setState(() => _busca = valor);
                    },
                    decoration: InputDecoration(
                      hintText: 'Buscar bem...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF80634E),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8DED3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8DED3)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Filtro de status
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF3B2417),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _botaoStatus('Todos', total),
                        _botaoStatus('Em uso', emUso),
                        _botaoStatus('Disponível', disponiveis),
                        _botaoStatus('Manutenção', manutencao),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Filtro de categoria
                  const Text(
                    'Categoria',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF3B2417),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8DED3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _categoriaSelecionada,
                        isExpanded: true,
                        items: _categorias.map((categoria) {
                          return DropdownMenuItem(
                            value: categoria,
                            child: Text(
                              categoria,
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (valor) {
                          if (valor != null) {
                            setState(() {
                              _categoriaSelecionada = valor;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Contador
                  Text(
                    '${_bensFiltrados.length} '
                    '${_bensFiltrados.length == 1 ? 'bem encontrado' : 'bens encontrados'}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF80634E),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Lista de patrimônios
                  if (_bensFiltrados.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 48,
                            color: Color(0xFF80634E),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Nenhum bem encontrado.',
                            style: TextStyle(color: Color(0xFF80634E)),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._bensFiltrados.map((bem) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PatrimonioCard(
                          nome: bem['nome']!,
                          tombo: bem['tombo']!,
                          categoria: bem['categoria']!,
                          local: bem['local']!,
                          status: bem['status']!,
                        ),
                      );
                    }),

                  const SizedBox(height: 16),
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

  Widget _botaoStatus(String status, int quantidade) {
    final selecionado = _statusSelecionado == status;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(status),
        selected: selecionado,
        showCheckmark: false,
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF5A3824),
        side: const BorderSide(color: Color(0xFFE8DED3)),
        labelStyle: TextStyle(
          color: selecionado ? Colors.white : const Color(0xFF5A3824),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        onSelected: (_) {
          setState(() => _statusSelecionado = status);
        },
      ),
    );
  }
}
