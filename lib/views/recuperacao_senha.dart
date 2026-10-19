import 'package:flutter/material.dart';

import '../contents/app_button.dart';
import '../contents/app_text.dart';
import '../routes/app_routes.dart';
import '../service/service.dart';
import 'verificar_codigo.dart';

class RecuperarSenhaPage extends StatefulWidget {
  const RecuperarSenhaPage({super.key});

  @override
  State<RecuperarSenhaPage> createState() => _RecuperarSenhaPageState();
}

class _RecuperarSenhaPageState extends State<RecuperarSenhaPage> {
  final TextEditingController emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _carregando = false;

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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),

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

                    // LOGO
                    Center(
                      child: Image.asset(
                        'assets/cadeado.png',
                        width: 300,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
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
                      texto: _carregando ? 'Enviando...' : 'Enviar código',
                      onPressed: _carregando
                          ? () {}
                          : () async {
                              setState(() => _carregando = true);
                              try {
                                await _authService.forgotPassword(
                                  emailController.text.trim().toLowerCase(),
                                );
                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => VerificarCodigoPage(
                                        email: emailController.text
                                            .trim()
                                            .toLowerCase(),
                                      ),
                                    ),
                                  );
                                }
                              } on AuthException catch (error) {
                                if (mounted)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error.message)),
                                  );
                              } finally {
                                if (mounted)
                                  setState(() => _carregando = false);
                              }
                            },
                    ),

                    const SizedBox(height: 24),

                    // VOLTAR PARA LOGIN
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
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
