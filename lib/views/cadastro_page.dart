import 'package:flutter/material.dart';

import 'package:sigpe/contents/app_text.dart';
import 'package:sigpe/contents/app_password.dart';
import 'package:sigpe/contents/app_button.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();

    super.dispose();
  }

  void cadastrar() {
    if (nomeController.text.isEmpty ||
        emailController.text.isEmpty ||
        senhaController.text.isEmpty ||
        confirmarSenhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos.'),
        ),
      );

      return;
    }

    if (senhaController.text != confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem.'),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cadastro realizado com sucesso!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EE),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 20,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // BOTÃO VOLTAR
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF3B2417),
                ),
              ),

              const SizedBox(height: 10),

              // LOGO
              Center(
                child: Image.asset(
                  'assets/Logo2.png',
                  width: 450,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              // TÍTULO
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Cadastro de Coordenador',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B2417),
                      ),
                    ),

                    SizedBox(height: 7),

                    Text(
                      'Crie sua conta de administrador',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // NOME
              AppText(
                label: 'Nome completo',
                hintText: 'Ex: Maria Silva',
                controller: nomeController,
              ),

              const SizedBox(height: 18),

              // E-MAIL
              AppText(
                label: 'E-mail institucional',
                hintText: 'exemplo@escola.edu.br',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 18),

              // SENHA
              AppPassword(
                label: 'Senha',
                hintText: 'Crie uma senha segura',
                controller: senhaController,
              ),

              const SizedBox(height: 18),

              // CONFIRMAR SENHA
              AppPassword(
                label: 'Confirmar senha',
                hintText: 'Repita a senha',
                controller: confirmarSenhaController,
              ),

              const SizedBox(height: 28),

              // BOTÃO CADASTRAR
              AppButton(
                texto: 'Cadastrar',
                onPressed: cadastrar,
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}