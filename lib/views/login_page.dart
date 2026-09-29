import 'package:flutter/material.dart';
import 'package:sigpe/views/cadastro_page.dart';
import 'package:sigpe/contents/app_button.dart';
import 'package:sigpe/contents/app_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool mostrarSenha = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EE),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 40,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // LOGO
              Center(
                child: Column(
                  children: [

                    Image.asset(
                      'assets/Logo2.png',
                      width: 400,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 55),

              // E-MAIL
              AppText(
                label: 'E-mail',
                hintText: 'seu@email.com',
                controller: emailController,
              ),

              const SizedBox(height: 20),

              // SENHA
              AppText(
                label: 'Senha',
                hintText: 'Digite sua senha',
                controller: senhaController,
                obscureText: !mostrarSenha,

                suffixIcon: IconButton(
                  icon: Icon(
                    mostrarSenha
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),

                  onPressed: () {
                    setState(() {
                      mostrarSenha = !mostrarSenha;
                    });
                  },
                ),
              ),

              const SizedBox(height: 28),

              // BOTÃO ENTRAR
              AppButton(
                texto: 'Entrar',
                onPressed: () {
                  // futuramente: validar login
                },
              ),

              const SizedBox(height: 25),

              // ESQUECEU SENHA
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Esqueceu sua senha?',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 45),

              // CADASTRO
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text(
                      'Não tem uma conta? ',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Cadastro(),
                          ),
                        );
                      },

                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Color(0xFF5A3824),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}