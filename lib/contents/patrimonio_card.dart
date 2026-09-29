import 'package:flutter/material.dart';
import 'package:sigpe/contents/app_status.dart';

class PatrimonioCard extends StatelessWidget {
  final String nome;
  final String tombo;
  final String categoria;
  final String local;
  final String status;
  final String? imagem;

  const PatrimonioCard({
    super.key,
    required this.nome,
    required this.tombo,
    required this.categoria,
    required this.local,
    required this.status,
    this.imagem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8DED3),
        ),
      ),

      child: Row(
        children: [
          // IMAGEM DO BEM
          Container(
            width: 55,
            height: 55,

            decoration: BoxDecoration(
              color: const Color(0xFFF1ECE6),
              borderRadius: BorderRadius.circular(8),
            ),

            child: imagem != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imagem!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.devices_outlined,
                    color: Color(0xFF5A3824),
                  ),
          ),

          const SizedBox(width: 12),

          // INFORMAÇÕES
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Tombo: $tombo',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),

                Text(
                  categoria,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),

                Text(
                  local,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          AppStatus(
            status: status,
          ),
        ],
      ),
    );
  }
}