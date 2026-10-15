import 'package:flutter/material.dart';

class DetalhesBemProfessorPage extends StatelessWidget {
  final Map<String, String> bem;

  const DetalhesBemProfessorPage({super.key, required this.bem});

  static const Color marrom = Color(0xFF4A2E1F);
  static const Color fundo = Color(0xFFF7F2EB);
  static const Color texto = Color(0xFF75685D);
  static const Color borda = Color(0xFFE8DED2);

  @override
  Widget build(BuildContext context) {
    final status = bem['status'] ?? 'Não informado';

    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: marrom,
                      size: 19,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Detalhes do equipamento',
                      style: TextStyle(
                        color: marrom,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cartão principal do equipamento
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: borda),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9DED2),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(
                              _iconeBem(bem['icone'], bem['nome']),
                              color: marrom,
                              size: 58,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            bem['nome'] ?? 'Equipamento',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: marrom,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tombamento: ${bem['tombo'] ?? 'Não informado'}',
                            style: const TextStyle(color: texto, fontSize: 13),
                          ),
                          const SizedBox(height: 14),
                          _statusBadge(status),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Informações do patrimônio',
                      style: TextStyle(
                        color: marrom,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: borda),
                      ),
                      child: Column(
                        children: [
                          _informacao(
                            Icons.inventory_2_outlined,
                            'Nome do equipamento',
                            bem['nome'],
                          ),
                          _divisor(),
                          _informacao(
                            Icons.tag,
                            'Número de tombamento',
                            bem['tombo'],
                          ),
                          _divisor(),
                          _informacao(
                            Icons.category_outlined,
                            'Categoria',
                            bem['categoria'],
                          ),
                          _divisor(),
                          _informacao(
                            Icons.business_outlined,
                            'Marca',
                            bem['marca'],
                          ),
                          _divisor(),
                          _informacao(
                            Icons.qr_code_2,
                            'Número de série',
                            bem['serie'],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Localização e responsabilidade',
                      style: TextStyle(
                        color: marrom,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: borda),
                      ),
                      child: Column(
                        children: [
                          _informacao(
                            Icons.location_on_outlined,
                            'Localização',
                            bem['local'],
                          ),
                          _divisor(),
                          _informacao(
                            Icons.calendar_today_outlined,
                            'Data de atribuição',
                            bem['data'],
                          ),
                          _divisor(),
                          _informacao(
                            Icons.person_outline,
                            'Responsável',
                            bem['responsavel'] ?? 'Professor responsável',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFE5D9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: marrom, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Estas informações são para consulta. '
                              'Para alterações no patrimônio, entre em '
                              'contato com o administrador do sistema.',
                              style: TextStyle(
                                color: marrom,
                                fontSize: 11,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _informacao(IconData icone, String titulo, String? valor) {
    final valorFinal = valor == null || valor.trim().isEmpty
        ? 'Não informado'
        : valor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: texto, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(color: texto, fontSize: 11),
                ),
                const SizedBox(height: 5),
                Text(
                  valorFinal,
                  style: const TextStyle(
                    color: marrom,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color cor;

    switch (status.toLowerCase()) {
      case 'disponível':
        cor = const Color(0xFF477653);
        break;
      case 'manutenção':
        cor = const Color(0xFFB66B32);
        break;
      default:
        cor = marrom;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _divisor() {
    return const Divider(height: 1, thickness: 0.6, color: borda);
  }

  IconData _iconeBem(String? tipo, String? nome) {
    switch (tipo) {
      case 'notebook':
        return Icons.laptop_chromebook;
      case 'projetor':
        return Icons.connected_tv;
      case 'tablet':
        return Icons.tablet_android;
    }

    final nomeNormalizado = (nome ?? '').toLowerCase();

    if (nomeNormalizado.contains('notebook') ||
        nomeNormalizado.contains('computador')) {
      return Icons.laptop_chromebook;
    }

    if (nomeNormalizado.contains('projetor')) {
      return Icons.connected_tv;
    }

    if (nomeNormalizado.contains('tablet')) {
      return Icons.tablet_android;
    }

    return Icons.devices_other;
  }
}
