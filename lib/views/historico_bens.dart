import 'package:flutter/material.dart';
import 'package:sigpe/service/service.dart';

class HistoricoBensPage extends StatefulWidget {
  final Map<String, String> bem;

  const HistoricoBensPage({super.key, required this.bem});

  static const Color marrom = Color(0xFF5A3824);
  static const Color texto = Color(0xFF3B2417);
  static const Color fundo = Color(0xFFF5EFE7);

  @override
  State<HistoricoBensPage> createState() => _HistoricoBensPageState();
}

class _HistoricoBensPageState extends State<HistoricoBensPage> {
  static const Color marrom = Color(0xFF5A3824);
  static const Color texto = Color(0xFF3B2417);
  static const Color fundo = Color(0xFFF5EFE7);
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> historico = [];
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    final id = int.tryParse(widget.bem['id'] ?? '');
    if (id == null) {
      carregando = false;
      erro = 'Patrimônio inválido.';
    } else {
      _carregar(id);
    }
  }

  Future<void> _carregar(int id) async {
    try {
      final items = await _authService.getPatrimonioHistory(id);
      if (mounted)
        setState(() {
          historico = items;
          carregando = false;
        });
    } on AuthException catch (error) {
      if (mounted)
        setState(() {
          erro = error.message;
          carregando = false;
        });
    }
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
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: marrom),
                  ),
                  const Expanded(
                    child: Text(
                      'Histórico do Bem',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: texto,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Informações do patrimônio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
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
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9DED2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        size: 30,
                        color: marrom,
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
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: texto,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tombamento: ${widget.bem['tombo'] ?? '-'}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.bem['categoria'] ?? 'Sem categoria',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Linha do tempo
            Expanded(
              child: carregando
                  ? const Center(child: CircularProgressIndicator())
                  : erro != null
                  ? Center(child: Text(erro!))
                  : Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE8DED3)),
                      ),
                      child: ListView.builder(
                        itemCount: historico.length,
                        itemBuilder: (context, index) {
                          final evento = historico[index];
                          final ultimo = index == historico.length - 1;

                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Linha e marcador
                                SizedBox(
                                  width: 28,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                            color: marrom,
                                            width: 3,
                                          ),
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 5,
                                            height: 5,
                                            decoration: const BoxDecoration(
                                              color: marrom,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (!ultimo)
                                        Expanded(
                                          child: Container(
                                            width: 2,
                                            color: const Color(0xFFC5B3A1),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Conteúdo do evento
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 28),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${evento['data']} - ${evento['hora']}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF80634E),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          evento['titulo']!,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: texto,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          evento['descricao']!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
