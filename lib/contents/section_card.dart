import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String titulo;
  final Widget child;
  final Widget? trailing;

  const SectionCard({
    super.key,
    required this.titulo,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE8DED3),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B2417),
                  ),
                ),
              ),

              if (trailing != null) trailing!,
            ],
          ),

          const SizedBox(height: 15),

          child,
        ],
      ),
    );
  }
}