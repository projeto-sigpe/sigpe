
import 'package:flutter/material.dart';
import 'package:sigpe/contents/app_button.dart';
import 'package:sigpe/contents/app_text.dart';
import 'package:sigpe/views/nova_senha.dart';

class VerificarCodigoPage extends StatefulWidget {
  const VerificarCodigoPage({super.key});

  @override
  State<VerificarCodigoPage> createState() =>
      _VerificarCodigoPageState();
}

class _VerificarCodigoPageState
    extends State<VerificarCodigoPage> {

  final TextEditingController codigoController =
      TextEditingController();

  @override
  void dispose() {
    codigoController.dispose();
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
                      Icons.verified_user_outlined,
                      size: 55,
                      color: Color(0xFF4B2D1D),
                    ),

                    const SizedBox(height: 18),

                    // TÍTULO
                    const Text(
                      'Verificar código',
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
                      'Enviamos um código para seu e-mail.\n'
                      'Digite-o abaixo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 38),

                    // CÓDIGO
                    AppText(
                      label: 'Código de verificação',
                      hintText: '000000',
                      controller: codigoController,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 25),

                    // BOTÃO
                    AppButton(
                      texto: 'Continuar',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NovaSenhaPage(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // REENVIAR
                    TextButton(
                      onPressed: () {
                        // futuramente reenviar código
                      },
                      child: const Text(
                        'Reenviar código (01:30)',
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
