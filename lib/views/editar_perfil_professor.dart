import 'package:flutter/material.dart';

class EditarPerfilProfessorPage extends StatefulWidget {
  final String nome;
  final String email;
  final String telefone;

  const EditarPerfilProfessorPage({
    super.key,
    required this.nome,
    required this.email,
    required this.telefone,
  });

  @override
  State<EditarPerfilProfessorPage> createState() =>
      _EditarPerfilProfessorPageState();
}

class _EditarPerfilProfessorPageState extends State<EditarPerfilProfessorPage> {
  static const Color marrom = Color(0xFF4A2E1F);
  static const Color fundo = Color(0xFFF7F2EB);
  static const Color texto = Color(0xFF75685D);
  static const Color borda = Color(0xFFE8DED2);

  final formKey = GlobalKey<FormState>();

  late final TextEditingController nomeController;
  late final TextEditingController emailController;
  late final TextEditingController telefoneController;

  @override
  void initState() {
    super.initState();

    nomeController = TextEditingController(text: widget.nome);
    emailController = TextEditingController(text: widget.email);
    telefoneController = TextEditingController(text: widget.telefone);
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    super.dispose();
  }

  void salvar() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    Navigator.pop(context, {
      'nome': nomeController.text.trim(),
      'email': emailController.text.trim(),
      'telefone': telefoneController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: marrom,
                        size: 18,
                      ),
                    ),
                    const Text(
                      'Editar Perfil',
                      style: TextStyle(
                        color: marrom,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                _campo(
                  label: 'Nome completo',
                  controller: nomeController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu nome completo.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 17),

                _campo(
                  label: 'E-mail',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final email = value?.trim() ?? '';

                    if (email.isEmpty) {
                      return 'Informe seu e-mail.';
                    }

                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(email)) {
                      return 'Digite um e-mail válido.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 17),

                _campo(
                  label: 'Telefone',
                  controller: telefoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu telefone.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 27),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: salvar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: marrom,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Salvar alterações',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: texto, fontSize: 12)),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: marrom, fontSize: 12),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: borda),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: borda),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: marrom),
            ),
            errorStyle: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
