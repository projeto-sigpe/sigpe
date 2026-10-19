import 'package:flutter/material.dart';
import 'package:sigpe/service/service.dart';

class CadastrarBensPage extends StatefulWidget {
  const CadastrarBensPage({super.key});

  @override
  State<CadastrarBensPage> createState() => _CadastrarBensPageState();
}

class _CadastrarBensPageState extends State<CadastrarBensPage> {
  final _formKey = GlobalKey<FormState>();

  final _tomboController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _marcaController = TextEditingController();
  final _serieController = TextEditingController();

  String? _categoriaSelecionada;
  final AuthService _authService = AuthService();
  bool _carregando = false;

  final List<String> _categorias = [
    'Informática',
    'Audiovisual',
    'Mobiliário',
    'Eletrodomésticos',
    'Material de escritório',
    'Outros',
  ];

  @override
  void dispose() {
    _tomboController.dispose();
    _descricaoController.dispose();
    _marcaController.dispose();
    _serieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE7),
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho
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
                      'Cadastrar Bem',
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

            // Formulário
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _campoTexto(
                        titulo: 'Tombamento',
                        dica: 'Ex: 0001',
                        controller: _tomboController,
                        obrigatorio: true,
                      ),

                      const SizedBox(height: 18),

                      _campoTexto(
                        titulo: 'Descrição',
                        dica: 'Ex: Notebook Dell Inspiron',
                        controller: _descricaoController,
                        obrigatorio: true,
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Categoria',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A3A2D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE8DED3)),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _categoriaSelecionada,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Selecione',
                          ),
                          isExpanded: true,
                          items: _categorias.map((categoria) {
                            return DropdownMenuItem<String>(
                              value: categoria,
                              child: Text(categoria),
                            );
                          }).toList(),
                          onChanged: (valor) {
                            setState(() {
                              _categoriaSelecionada = valor;
                            });
                          },
                          validator: (valor) {
                            if (valor == null || valor.isEmpty) {
                              return 'Selecione uma categoria';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 18),

                      _campoTexto(
                        titulo: 'Marca',
                        dica: 'Ex: Dell',
                        controller: _marcaController,
                      ),

                      const SizedBox(height: 18),

                      _campoTexto(
                        titulo: 'Número de série',
                        dica: 'Ex: SN123456',
                        controller: _serieController,
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _carregando ? null : _salvarBem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A3824),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _carregando ? 'Salvando...' : 'Salvar',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campoTexto({
    required String titulo,
    required String dica,
    required TextEditingController controller,
    bool obrigatorio = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4A3A2D),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: dica,
            hintStyle: const TextStyle(color: Color(0xFFAAA39C), fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE8DED3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE8DED3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF80634E),
                width: 1.5,
              ),
            ),
          ),
          validator: (valor) {
            if (obrigatorio && (valor == null || valor.trim().isEmpty)) {
              return 'Preencha este campo';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _salvarBem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _carregando = true);
    try {
      await _authService.createPatrimonio({
        'codigo': _tomboController.text.trim(),
        'nome': _descricaoController.text.trim(),
        'categoria': _categoriaSelecionada!,
        'marca': _marcaController.text.trim(),
        'numeroSerie': _serieController.text.trim(),
      });
      if (!mounted) return;
      Navigator.pop(context, true);
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }
}
