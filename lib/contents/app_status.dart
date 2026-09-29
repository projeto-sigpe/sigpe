import 'package:flutter/material.dart';

class AppStatus extends StatelessWidget {
  final String status;

  const AppStatus({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color background;
    Color texto;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'disponível':
        background = const Color(0xFFDDEDDD);
        texto = const Color(0xFF4D7651);
        icon = Icons.check_circle_outline;
        break;

      case 'manutenção':
        background = const Color(0xFFF2DEC9);
        texto = const Color(0xFF9A6338);
        icon = Icons.build_outlined;
        break;

      default:
        background = const Color(0xFFE7DED5);
        texto = const Color(0xFF5A3824);
        icon = Icons.inventory_2_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: texto,
          ),

          const SizedBox(width: 4),

          Text(
            status,
            style: TextStyle(
              color: texto,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}