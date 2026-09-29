import 'package:flutter/material.dart';

class ProfessorCard extends StatelessWidget {
  final String nome;
  final String disciplina;
  final String matricula;
  final int quantidadeBens;
  final String? imagem;

  const ProfessorCard({
    super.key,
    required this.nome,
    required this.disciplina,
    required this.matricula,
    required this.quantidadeBens,
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
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFFE9DED2),

            backgroundImage: imagem != null
                ? AssetImage(imagem!)
                : null,

            child: imagem == null
                ? const Icon(
                    Icons.person,
                    color: Color(0xFF5A3824),
                  )
                : null,
          ),

          const SizedBox(width: 12),

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
                  disciplina,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),

                Text(
                  'Matrícula: $matricula',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              Text(
                '$quantidadeBens',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const Text(
                'bens',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}