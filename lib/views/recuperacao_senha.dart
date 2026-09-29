import 'package:flutter/material.dart';
import 'package:sigpe/views/verificar_codigo.dart';

import '../contents/app_button.dart';
import '../contents/app_text.dart';


class RecuperarSenhaPage extends StatefulWidget {
  const RecuperarSenhaPage({super.key});

  @override
  State<RecuperarSenhaPage> createState() => _RecuperarSenhaPageState();
}

class _RecuperarSenhaPageState extends State<RecuperarSenhaPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
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
                      'Recuperar senha',
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
                      'Digite seu e-mail para receber\n'
                      'o código de verificação.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 38),

                    // CAMPO
                    AppText(
                      label: 'E-mail',
                      hintText: 'seu@email.com',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 25),

                    // BOTÃO
                    AppButton(
                      texto: 'Enviar código',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const VerificarCodigoPage(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // VOLTAR PARA LOGIN
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Voltar para o login',
                        style: TextStyle(
                          color: Color(0xFF6B584A),
                          fontSize: 13,
                        ),
                      ),
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