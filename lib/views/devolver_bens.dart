import 'package:flutter/material.dart';
import 'package:sigpe/service/service.dart';

class DevolverBensPage extends StatefulWidget {
  final Map<String, String> bem;

  const DevolverBensPage({super.key, required this.bem});

  @override
  State<DevolverBensPage> createState() => _DevolverBensPageState();
}

class _DevolverBensPageState extends State<DevolverBensPage> {
  final _formKey = GlobalKey<FormState>();
  final _motivoController = TextEditingController();

  String? _condicaoSelecionada;
  final AuthService _authService = AuthService();
  bool _salvando = false;

  final List<String> _condicoes = [
    'Em bom estado',
    'Com avarias',
    'Necessita de manutenção',
  ];

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
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
                      'Devolver Bem',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cartaoBem(),

                      const SizedBox(height: 24),

                      const Text(
                        'Condição do bem',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B2417),
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
                          value: _condicaoSelecionada,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Selecione a condição',
                          ),
                          items: _condicoes.map((condicao) {
                            return DropdownMenuItem<String>(
                              value: condicao,
                              child: Text(
                                condicao,
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (valor) {
                            setState(() {
                              _condicaoSelecionada = valor;
                            });
                          },
                          validator: (valor) {
                            if (valor == null) {
                              return 'Selecione a condição do bem';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Motivo da devolução',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B2417),
                        ),
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _motivoController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Informe o motivo da devolução...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE8DED3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE8DED3),
                            ),
                          ),
                        ),
                        validator: (valor) {
                          if (valor == null || valor.trim().isEmpty) {
                            return 'Informe o motivo da devolução';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _salvando ? null : _devolverBem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A3824),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            _salvando ? 'Salvando...' : 'Confirmar devolução',
                            style: TextStyle(fontWeight: FontWeight.w600),
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

  Widget _cartaoBem() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8DED3)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE9DED2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Color(0xFF5A3824),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bem['nome'] ?? 'Bem patrimonial',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B2417),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Tombo: ${widget.bem['tombo'] ?? '-'}',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Text(
                  widget.bem['categoria'] ?? 'Sem categoria',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
Future<void> _devolverBem() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  final id = int.tryParse(widget.bem['id'] ?? '');

  if (id == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Não foi possível identificar o patrimônio.'),
      ),
    );
    return;
  }

  setState(() => _salvando = true);

  try {
    await _authService.unassignPatrimonio(
      id,
      motivo: [
        'Condição: $_condicaoSelecionada',
        'Motivo: ${_motivoController.text.trim()}',
      ].join(' | '),
    );

    if (!mounted) return;

    Navigator.pop(context, true);
  } on AuthException catch (error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.message)),
    );
  } catch (error, stackTrace) {
    debugPrint('Erro ao devolver patrimônio: $error');
    debugPrint('$stackTrace');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Não foi possível registrar a devolução.'),
      ),
    );
  } finally {
    if (mounted) {
      setState(() => _salvando = false);
    }
  }
}

}
