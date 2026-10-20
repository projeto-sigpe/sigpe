import 'package:flutter/material.dart';
import 'package:sigpe/service/service.dart';

class CadastroProfessorPage extends StatefulWidget {
  const CadastroProfessorPage({super.key});

  @override
  State<CadastroProfessorPage> createState() => _CadastroProfessorPageState();
}

class _CadastroProfessorPageState extends State<CadastroProfessorPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _departamentoController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _carregando = false;
  bool _mostrarSenha = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _matriculaController.dispose();
    _departamentoController.dispose();
    super.dispose();
  }

  String? _validarObrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Este campo é obrigatório.';
    }
    return null;
  }

  String? _validarEmail(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o e-mail.';
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(valor.trim())) {
      return 'Digite um e-mail válido.';
    }

    return null;
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    try {
      await _authService.cadastrarProfessor(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        password: _senhaController.text,
        matricula: _matriculaController.text.trim(),
        departamento: _departamentoController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Professor cadastrado com sucesso!')),
      );

      Navigator.pop(context, true);
    } on AuthException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar professor: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  Widget _campo({
    required String label,
    required String dica,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType tipo = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF3B2417),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: tipo,
          decoration: InputDecoration(
            hintText: dica,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EFE7),
        foregroundColor: const Color(0xFF3B2417),
        elevation: 0,
        title: const Text(
          'Cadastrar professor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Icon(
                Icons.person_add_alt_1,
                size: 56,
                color: Color(0xFF5A3824),
              ),
              const SizedBox(height: 12),
              const Text(
                'Dados do professor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B2417),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Preencha as informações para criar o acesso.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 28),

              _campo(
                label: 'Nome completo',
                dica: 'Digite o nome do professor',
                controller: _nomeController,
                validator: _validarObrigatorio,
              ),
              const SizedBox(height: 18),

              _campo(
                label: 'E-mail',
                dica: 'professor@escola.com',
                controller: _emailController,
                validator: _validarEmail,
                tipo: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),

              const Text(
                'Senha inicial',
                style: TextStyle(
                  color: Color(0xFF3B2417),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _senhaController,
                obscureText: !_mostrarSenha,
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Informe uma senha inicial.';
                  }
                  if (valor.length < 8) {
                    return 'A senha deve ter pelo menos 8 caracteres.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Crie uma senha inicial',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _mostrarSenha = !_mostrarSenha;
                      });
                    },
                    icon: Icon(
                      _mostrarSenha ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              _campo(
                label: 'Matrícula',
                dica: 'Número de matrícula',
                controller: _matriculaController,
                validator: _validarObrigatorio,
              ),
              const SizedBox(height: 18),

              _campo(
                label: 'Departamento',
                dica: 'Ex.: Matemática',
                controller: _departamentoController,
                validator: _validarObrigatorio,
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _carregando ? null : _cadastrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A3824),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _carregando
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Cadastrar professor',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
