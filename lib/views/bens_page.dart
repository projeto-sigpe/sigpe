
import 'package:flutter/material.dart';
import 'package:sigpe/contents/bottom_nav.dart';
import 'package:sigpe/contents/patrimonio_card.dart';
import 'package:sigpe/views/atribuir_bens.dart';
import 'package:sigpe/views/cadastrar_bens.dart';
import 'package:sigpe/views/devolver_bens.dart';
import 'package:sigpe/views/historico_bens.dart';
import 'package:sigpe/service/service.dart';
import 'package:sigpe/views/dashboard.dart';
import 'package:sigpe/views/professores_page.dart';

class BensPage extends StatefulWidget {
  const BensPage({super.key});

  @override
  State<BensPage> createState() => _BensPageState();
}

class _BensPageState extends State<BensPage> {
  static const Color marrom = Color(0xFF4A2E1F);
  static const Color fundo = Color(0xFFF5EFE7);
  static const Color bege = Color(0xFFE9DED2);

  int _currentIndex = 1;

  String _busca = '';
  String _statusSelecionado = 'Todos';
  String _categoriaSelecionada = 'Todas as categorias';

  String _formatarStatus(String status) {
    switch (status.toLowerCase()) {
      case 'em_uso':
        return 'Em uso';
      case 'disponivel':
      case 'disponível':
        return 'Disponível';
      case 'em_manutencao':
      case 'em manutenção':
        return 'Manutenção';
      case 'baixado':
        return 'Baixado';
      default:
        return status;
    }
  }

  final List<Map<String, String>> _bens = [];
  final AuthService _authService = AuthService();

  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarBens();
  }

  Future<void> _carregarBens() async {
    if (!mounted) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      debugPrint('SIGPE: buscando patrimônios...');

      final items = await _authService.getPatrimonios();
      final bensConvertidos = items.map(_mapBem).toList();

      debugPrint(
        'SIGPE: ${bensConvertidos.length} patrimônios recebidos.',
      );
      debugPrint('SIGPE: patrimônios convertidos: $bensConvertidos');

      if (!mounted) return;

      setState(() {
        _bens
          ..clear()
          ..addAll(bensConvertidos);

        // Evita manter uma categoria que não existe mais na lista.
        if (!_categorias.contains(_categoriaSelecionada)) {
          _categoriaSelecionada = 'Todas as categorias';
        }
      });
    } catch (error, stackTrace) {
      debugPrint('SIGPE ERRO ao carregar patrimônios: $error');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        _erro = error is AuthException
            ? error.message
            : 'Não foi possível carregar os patrimônios. '
                'Verifique a conexão e a resposta da API.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  String _lerCampo(
    Map<String, dynamic> item,
    List<String> chaves, {
    String padrao = '-',
  }) {
    for (final chave in chaves) {
      final valor = item[chave];

      if (valor != null && valor.toString().trim().isNotEmpty) {
        return valor.toString().trim();
      }
    }

    return padrao;
  }

  Map<String, String> _mapBem(Map<String, dynamic> item) {
    return {
      'id': _lerCampo(item, ['id'], padrao: ''),
      'nome': _lerCampo(item, [
        'nome',
        'descricao',
        'description',
        'name',
      ]),
      'tombo': _lerCampo(item, [
        'codigo',
        'tombo',
        'numeroTombo',
        'numero_tombo',
        'codigoPatrimonio',
        'codigo_patrimonio',
      ]),
      'categoria': _lerCampo(item, [
        'categoria',
        'nomeCategoria',
        'nome_categoria',
        'tipo',
      ]),
      'local': _lerCampo(item, [
        'localizacao',
        'localização',
        'local',
        'sala',
      ]),
      'status': _lerCampo(item, [
        'status',
        'situacao',
        'situação',
        'estado',
      ]),
      'marca': _lerCampo(item, ['marca', 'fabricante']),
      'serie': _lerCampo(item, [
        'numeroSerie',
        'numero_serie',
        'numeroDeSerie',
        'serial',
      ]),
    };
  }

  String _normalizar(String texto) {
    return texto
        .toLowerCase()
        .trim()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c')
        .replaceAll('_', ' ');
  }

  List<String> get _categorias {
    final existentes = _bens
        .map((bem) => bem['categoria'] ?? '')
        .where(
          (categoria) =>
              categoria.isNotEmpty && categoria != '-',
        )
        .toSet()
        .toList();

    existentes.sort();

    return [
      'Todas as categorias',
      ...existentes,
    ];
  }
  Map<String, String> _mapBem(Map<String, dynamic> item) => {
    'id': item['id']?.toString() ?? '',
    'nome': item['nome']?.toString() ?? '-',
    'tombo': item['codigo']?.toString() ?? '-',
    'categoria': item['categoria']?.toString() ?? '-',
    'local': item['localizacao']?.toString() ?? '-',
    'status': _formatarStatus(item['status']?.toString() ?? '-'),
    'marca': item['marca']?.toString() ?? '-',
    'serie': item['numeroSerie']?.toString() ?? '-',
  };

  final List<String> _categorias = [
    'Todas as categorias',
    'Informática',
    'Audiovisual',
    'Mobiliário',
  ];

  List<Map<String, String>> get _bensFiltrados {
    return _bens.where((bem) {
      final nome = _normalizar(bem['nome'] ?? '');
      final tombo = _normalizar(bem['tombo'] ?? '');
      final categoria = _normalizar(bem['categoria'] ?? '');
      final status = _normalizar(bem['status'] ?? '');
      final busca = _normalizar(_busca);

      final correspondeBusca =
          nome.contains(busca) ||
          tombo.contains(busca) ||
          categoria.contains(busca);

      final correspondeStatus =
          _statusSelecionado == 'Todos' ||
          status == _normalizar(_statusSelecionado);

      final correspondeCategoria =
          _categoriaSelecionada == 'Todas as categorias' ||
          categoria == _normalizar(_categoriaSelecionada);

      return correspondeBusca &&
          correspondeStatus &&
          correspondeCategoria;
    }).toList();
  }

  int _contarStatus(String statusDesejado) {
    return _bens.where((bem) {
      return _normalizar(bem['status'] ?? '') ==
          _normalizar(statusDesejado);
    }).length;
  }

  Future<void> _abrirAtribuicao(
    Map<String, String> bem,
  ) async {
    Navigator.pop(context);

    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AtribuirBensPage(bem: bem),
      ),
    );

    if (resultado == true && mounted) {
      await _carregarBens();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Patrimônio atribuído com sucesso!'),
        ),
      );
    }
  }

  Future<void> _abrirDevolucao(
    Map<String, String> bem,
  ) async {
    Navigator.pop(context);

    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DevolverBensPage(bem: bem),
      ),
    );

    if (resultado == true && mounted) {
      await _carregarBens();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Patrimônio devolvido com sucesso!'),
        ),
      );
    }
  }

  void _mostrarOpcoesBens(Map<String, String> bem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: fundo,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2C4B6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                bem['nome'] ?? 'Patrimônio',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B2417),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tombo: ${bem['tombo'] ?? '-'}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF80634E),
                ),
              ),
              const SizedBox(height: 18),
              _opcaoBem(
                icone: Icons.history,
                titulo: 'Ver histórico',
                descricao: 'Consultar movimentações do patrimônio',
                aoTocar: () {
                  Navigator.pop(context);

                  Navigator.push(
                    this.context,
                    MaterialPageRoute(
                      builder: (_) => HistoricoBensPage(bem: bem),
                    ),
                  );
                },
              ),
              _opcaoBem(
                icone: Icons.person_add_alt_1,
                titulo: 'Atribuir bem',
                descricao: 'Vincular o bem a um professor',
                aoTocar: () => _abrirAtribuicao(bem),
              ),
              _opcaoBem(
                icone: Icons.assignment_return_outlined,
                titulo: 'Devolver bem',
                descricao: 'Registrar a devolução do patrimônio',
                aoTocar: () => _abrirDevolucao(bem),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _opcaoBem({
    required IconData icone,
    required String titulo,
    required String descricao,
    required VoidCallback aoTocar,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: bege,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icone,
          color: const Color(0xFF5A3824),
        ),
      ),
      title: Text(
        titulo,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF3B2417),
        ),
      ),
      subtitle: Text(
        descricao,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF80634E),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFF80634E),
      ),
      onTap: aoTocar,
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _bens.length;
    final emUso = _contarStatus('Em uso');
    final disponiveis = _contarStatus('Disponível');
    final manutencao = _contarStatus('Manutenção');

    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
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
                      color: marrom,
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
                      final cadastrado = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CadastrarBensPage(),
                        ),
                      );

                      if (cadastrado == true && mounted) {
                        await _carregarBens();

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Bem cadastrado com sucesso!',
                            ),
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
              child: _carregando
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: marrom,
                      ),
                    )
                  : _erro != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.cloud_off_outlined,
                                  size: 44,
                                  color: Color(0xFF80634E),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _erro!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: marrom,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: _carregarBens,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Tentar novamente'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: marrom,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _carregarBens,
                          color: marrom,
                          child: ListView(
                            physics:
                                const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            children: [
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
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE8DED3),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE8DED3),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
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
                                    _botaoStatus(
                                      'Disponível',
                                      disponiveis,
                                    ),
                                    _botaoStatus(
                                      'Manutenção',
                                      manutencao,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE8DED3),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _categorias.contains(
                                      _categoriaSelecionada,
                                    )
                                        ? _categoriaSelecionada
                                        : 'Todas as categorias',
                                    isExpanded: true,
                                    items: _categorias.map((categoria) {
                                      return DropdownMenuItem<String>(
                                        value: categoria,
                                        child: Text(
                                          categoria,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
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
                              Text(
                                '${_bensFiltrados.length} '
                                '${_bensFiltrados.length == 1 ? 'bem encontrado' : 'bens encontrados'}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF80634E),
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (_bensFiltrados.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 40,
                                  ),
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
                                        style: TextStyle(
                                          color: Color(0xFF80634E),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                ..._bensFiltrados.map((bem) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12,
                                    ),
                                    child: InkWell(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      onTap: () =>
                                          _mostrarOpcoesBens(bem),
                                      child: PatrimonioCard(
                                        nome: bem['nome']!,
                                        tombo: bem['tombo']!,
                                        categoria: bem['categoria']!,
                                        local: bem['local']!,
                                        status: bem['status']!,
                                      ),
                                    ),
                                  );
                                }),
                              const SizedBox(height: 16),
                            ],
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
            setState(() {
              _currentIndex = 1;
            });
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfessoresPage()),
            );
          }
        },
      ),
    );
  }

  Widget _botaoStatus(String status, int quantidade) {
    final selecionado = _statusSelecionado == status;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text('$status ($quantidade)'),
        selected: selecionado,
        showCheckmark: false,
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF5A3824),
        side: const BorderSide(
          color: Color(0xFFE8DED3),
        ),
        labelStyle: TextStyle(
          color: selecionado
              ? Colors.white
              : const Color(0xFF5A3824),
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
