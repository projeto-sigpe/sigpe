import 'package:flutter/material.dart';

class AppPassword extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AppPassword({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
  });

  @override
  State<AppPassword> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPassword> {
  bool mostrarSenha = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3B2417),
          ),
        ),

        const SizedBox(height: 7),

        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: !mostrarSenha,
          decoration: InputDecoration(
            hintText: widget.hintText,

            filled: true,
            fillColor: Colors.white,

            suffixIcon: IconButton(
              icon: Icon(
                mostrarSenha ? Icons.visibility : Icons.visibility_off,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  mostrarSenha = !mostrarSenha;
                });
              },
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF5A3824)),
            ),
          ),
        ),
      ],
    );
  }
}
