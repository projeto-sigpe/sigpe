
import 'package:flutter/material.dart';
import 'package:sigpe/service/service.dart';

class HistoricoBensPage extends StatefulWidget {
  final Map<String, String> bem;

  const HistoricoBensPage({
    super.key,
    required this.bem,
  });

  static const Color marrom = Color(0xFF5A3824);
  static const Color texto = Color(0xFF3B2417);
  static const Color fundo = Color(0xFFF5EFE7);

  @override
  State<HistoricoBensPage> createState() => _HistoricoBensPageState();
}

class _HistoricoBensPageState extends State<HistoricoBensPage> {
  final AuthService _authService = AuthService();

  List<Map<String, dynamic>> historico = [];
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final id = int.tryParse(widget.bem['id'] ?? '');

    if (id == null) {
      setState(() {
        carregando = false;
        erro = 'O ID deste patrimônio é inválido.';
      });
      return;
    }

    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final items = await _authService.getPatrimonioHistory(id);

      if (!mounted) return;

      setState(() {
        historico = items;
        carregando = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Erro ao carregar histórico: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        erro = e is AuthException
            ? e.message
            : 'Não foi possível carregar o histórico. Tente novamente.';
        carregando = false;
      });
    }
  }

  String _campo(
    Map<String, dynamic> evento,
    List<String> chaves, {
    String padrao = 'Não informado',
  }) {
    for (final chave in chaves) {
      final valor = evento[chave];

      if (valor != null && valor.toString().trim().isNotEmpty) {
        return valor.toString().trim();
      }
    }

    return padrao;
  }

  String _dataHora(Map<String, dynamic> evento) {
    final data = _campo(
      evento,
      ['data', 'dataHora', 'data_hora', 'createdAt', 'created_at'],
      padrao: '',
    );

    final hora = _campo(
      evento,
      ['hora', 'horario', 'horário'],
      padrao: '',
    );

    if (data.isEmpty && hora.isEmpty) {
      return 'Data não informada';
    }

    // Algumas APIs retornam data e hora juntas em ISO 8601.
    final dataConvertida = DateTime.tryParse(data);

    if (dataConvertida != null) {
      final d = dataConvertida.toLocal();

      final dia = d.day.toString().padLeft(2, '0');
      final mes = d.month.toString().padLeft(2, '0');
      final ano = d.year.toString();
      final h = d.hour.toString().padLeft(2, '0');
      final m = d.minute.toString().padLeft(2, '0');

      return '$dia/$mes/$ano às $h:$m';
    }

    return [
      data,
      if (hora.isNotEmpty) hora,
    ].join(' às ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HistoricoBensPage.fundo,
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
                      color: HistoricoBensPage.marrom,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Histórico do Bem',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: HistoricoBensPage.texto,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Atualizar histórico',
                    onPressed: carregando ? null : _carregar,
                    icon: const Icon(
                      Icons.refresh,
                      color: HistoricoBensPage.marrom,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFE8DED3),
                  ),
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
                        color: HistoricoBensPage.marrom,
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
                              color: HistoricoBensPage.texto,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tombo: ${widget.bem['tombo'] ?? '-'}',
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

            Expanded(
              child: _conteudoHistorico(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _conteudoHistorico() {
    if (carregando) {
      return const Center(
        child: CircularProgressIndicator(
          color: HistoricoBensPage.marrom,
        ),
      );
    }

    if (erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 42,
                color: HistoricoBensPage.marrom,
              ),
              const SizedBox(height: 12),
              Text(
                erro!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: HistoricoBensPage.texto,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _carregar,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HistoricoBensPage.marrom,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (historico.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.history,
                size: 48,
                color: Color(0xFF80634E),
              ),
              const SizedBox(height: 12),
              const Text(
                'Nenhuma movimentação registrada.',
                style: TextStyle(
                  color: Color(0xFF80634E),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _carregar,
                icon: const Icon(Icons.refresh),
                label: const Text('Atualizar'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE8DED3),
        ),
      ),
      child: ListView.builder(
        itemCount: historico.length,
        itemBuilder: (context, index) {
          final evento = historico[index];
          final ultimo = index == historico.length - 1;

          final titulo = _campo(
            evento,
            ['titulo', 'acao', 'ação', 'tipo', 'operacao', 'operacaoTipo'],
            padrao: 'Movimentação do patrimônio',
          );

          final descricao = _campo(
            evento,
            [
              'descricao',
              'descrição',
              'observacoes',
              'observações',
              'detalhes',
              'motivo',
              'description',
            ],
            padrao: 'Sem detalhes adicionais.',
          );

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            color: HistoricoBensPage.marrom,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: HistoricoBensPage.marrom,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _dataHora(evento),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF80634E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          titulo,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: HistoricoBensPage.texto,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          descricao,
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
    );
  }
}
