import 'package:flutter/material.dart';
import 'package:sigpe/contents/app_button.dart';
import 'package:sigpe/contents/app_password.dart';

class NovaSenhaPage extends StatefulWidget {
  const NovaSenhaPage({super.key});

  @override
  State<NovaSenhaPage> createState() => _NovaSenhaPageState();
}

class _NovaSenhaPageState extends State<NovaSenhaPage> {

  final TextEditingController novaSenhaController =
      TextEditingController();

  final TextEditingController confirmarSenhaController =
      TextEditingController();

  @override
  void dispose() {
    novaSenhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EC),

      body: SafeArea(
        child: Stack(
          children: [

            // FUNDO INFERIOR
            Positioned(
              bottom: 0,
              left: -80,
              right: -80,
              child: Container(
                height: 150,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2E9DE),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(180),
                    topRight: Radius.circular(180),
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                ),

                child: Column(
                  children: [

                    // VOLTAR
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: Color(0xFF5A3824),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ÍCONE
                    const Icon(
                      Icons.lock_outline,
                      size: 55,
                      color: Color(0xFF4B2D1D),
                    ),

                    const SizedBox(height: 18),

                    // TÍTULO
                    const Text(
                      'Nova senha',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B2417),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // DESCRIÇÃO
                    const Text(
                      'Defina sua nova senha.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 38),

                    // NOVA SENHA
                    AppPassword(
                      label: 'Nova senha',
                      hintText: 'Digite sua nova senha',
                      controller: novaSenhaController,
                    ),

                    const SizedBox(height: 22),

                    // CONFIRMAR SENHA
                    AppPassword(
                      label: 'Confirmar senha',
                      hintText: 'Confirme sua nova senha',
                      controller: confirmarSenhaController,
                    ),

                    const SizedBox(height: 28),

                    // SALVAR
                    AppButton(
                      texto: 'Salvar',
                      onPressed: () {
                        if (novaSenhaController.text ==
                            confirmarSenhaController.text) {

                          // futuramente salvar senha

                          Navigator.popUntil(
                            context,
                            (route) => route.isFirst,
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}