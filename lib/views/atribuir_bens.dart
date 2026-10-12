import 'package:flutter/material.dart';

class AtribuirBensPage extends StatefulWidget {
  final Map<String, String> bem;

  const AtribuirBensPage({super.key, required this.bem});

  @override
  State<AtribuirBensPage> createState() => _AtribuirBensPageState();
}

class _AtribuirBensPageState extends State<AtribuirBensPage> {
  final _formKey = GlobalKey<FormState>();
  final _observacoesController = TextEditingController();

  String? _professorSelecionado;

  final List<String> _professores = [
    'Ana Souza',
    'Carlos Oliveira',
    'Juliana Lima',
    'Marcos Santos',
  ];

  @override
  void dispose() {
    _observacoesController.dispose();
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
                      'Atribuir Bem',
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
                        'Professor responsável',
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
                          value: _professorSelecionado,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Selecione um professor',
                          ),
                          items: _professores.map((professor) {
                            return DropdownMenuItem<String>(
                              value: professor,
                              child: Text(professor),
                            );
                          }).toList(),
                          onChanged: (valor) {
                            setState(() {
                              _professorSelecionado = valor;
                            });
                          },
                          validator: (valor) {
                            if (valor == null) {
                              return 'Selecione um professor';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Observações (opcional)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B2417),
                        ),
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _observacoesController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Digite alguma observação...',
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
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _atribuirBem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A3824),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Confirmar atribuição',
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

  void _atribuirBem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(context, {
      'professor': _professorSelecionado!,
      'observacoes': _observacoesController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Atribuição registrada nesta demonstração.'),
      ),
    );
  }
}
