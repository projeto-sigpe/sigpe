import 'package:flutter/material.dart';
import 'package:sigpe/contents/professor_bottom_nav.dart';
import 'package:sigpe/views/bens_professor.dart';
import 'package:sigpe/views/dashboard_professor.dart';
import 'package:sigpe/views/editar_perfil_professor.dart';
import 'package:sigpe/service/service.dart';

class PerfilProfessorPage extends StatefulWidget {
  const PerfilProfessorPage({super.key});

  @override
  State<PerfilProfessorPage> createState() => _PerfilProfessorPageState();
}

class _PerfilProfessorPageState extends State<PerfilProfessorPage> {
  static const Color marrom = Color(0xFF4A2E1F);
  static const Color fundo = Color(0xFFF7F2EB);
  static const Color texto = Color(0xFF75685D);
  static const Color borda = Color(0xFFE8DED2);

  final AuthService _authService = AuthService();
  String nome = '-';
  String email = '-';
  String telefone = '-';
  String matricula = '-';
  String departamento = '-';

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    try {
      final perfil = await _authService.getProfile();
      if (!mounted) return;
      setState(() {
        nome = perfil['nome']?.toString() ?? nome;
        email = perfil['email']?.toString() ?? email;
        telefone = perfil['telefone']?.toString() ?? telefone;
        matricula = perfil['matricula']?.toString() ?? matricula;
        departamento = perfil['departamento']?.toString() ?? departamento;
      });
    } on AuthException catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  Future<void> _editarPerfil() async {
    final resultado = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditarPerfilProfessorPage(
          nome: nome,
          email: email,
          telefone: telefone,
        ),
      ),
    );

    if (resultado == null || !mounted) return;

    setState(() {
      nome = resultado['nome'] ?? nome;
      email = resultado['email'] ?? email;
      telefone = resultado['telefone'] ?? telefone;
    });

    try {
      await _authService.updateProfile(resultado);
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!')),
        );
    } on AuthException catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  void _alterarSenha() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return _DialogAlterarSenha(
          fundo: fundo,
          marrom: marrom,
          texto: texto,
          borda: borda,
          authService: AuthService(),
        );
      },
    );
  }

  Widget _campoSenha({
    required TextEditingController controller,
    required String label,
    required bool ocultar,
    required VoidCallback alternar,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: ocultar,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Preencha este campo.';
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: texto),
        suffixIcon: IconButton(
          onPressed: alternar,
          icon: Icon(
            ocultar ? Icons.visibility_off : Icons.visibility,
            size: 18,
            color: texto,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: borda),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: borda),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 16, 14),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardProfessorPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF4A2E1F),
                    ),
                  ),
                  const Text(
                    'Perfil (Professor)',
                    style: TextStyle(
                      color: marrom,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Foto e identificação
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 27,
                          backgroundColor: Color(0xFFE4D3C1),
                          child: Icon(Icons.person, color: marrom, size: 35),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nome,
                                style: const TextStyle(
                                  color: marrom,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Professor',
                                style: TextStyle(color: texto, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Dados cadastrais',
                      style: TextStyle(
                        color: marrom,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borda),
                      ),
                      child: Column(
                        children: [
                          _dado('Matrícula', matricula),
                          _divisor(),
                          _dado('Departamento', departamento),
                          _divisor(),
                          _dado('E-mail', email),
                          _divisor(),
                          _dado('Telefone', telefone),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: _alterarSenha,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: marrom,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Alterar senha',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: OutlinedButton(
                              onPressed: _editarPerfil,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: marrom,
                                side: const BorderSide(color: marrom),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Editar perfil',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: ProfessorBottomNav(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardProfessorPage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const BensProfessorPage()),
            );
          }
        },
      ),
    );
  }

  Widget _dado(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(color: texto, fontSize: 10)),
          const SizedBox(height: 4),
          Text(valor, style: const TextStyle(color: marrom, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _divisor() {
    return const Divider(height: 1, thickness: 0.6, color: borda);
  }
}

class _DialogAlterarSenha extends StatefulWidget {
  final Color fundo;
  final Color marrom;
  final Color texto;
  final Color borda;
  final AuthService authService;

  const _DialogAlterarSenha({
    required this.fundo,
    required this.marrom,
    required this.texto,
    required this.borda,
    required this.authService,
  });

  @override
  State<_DialogAlterarSenha> createState() => _DialogAlterarSenhaState();
}

class _DialogAlterarSenhaState extends State<_DialogAlterarSenha> {
  final _formKey = GlobalKey<FormState>();
  final _senhaAtualController = TextEditingController();
  final _senhaNovaController = TextEditingController();
  final _confirmarController = TextEditingController();

  bool _ocultar = true;

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _senhaNovaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Widget _campo({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: _ocultar,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Preencha este campo.';
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() => _ocultar = !_ocultar);
          },
          icon: Icon(_ocultar ? Icons.visibility_off : Icons.visibility),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(color: widget.borda),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.fundo,
      title: Text(
        'Alterar senha',
        style: TextStyle(color: widget.marrom, fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _campo(controller: _senhaAtualController, label: 'Senha atual'),
              const SizedBox(height: 12),
              _campo(
                controller: _senhaNovaController,
                label: 'Nova senha',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a nova senha.';
                  }
                  if (value.length < 8) {
                    return 'Use pelo menos 8 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _campo(
                controller: _confirmarController,
                label: 'Confirmar nova senha',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirme a nova senha.';
                  }
                  if (value != _senhaNovaController.text) {
                    return 'As senhas não coincidem.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Botão Cancelar apenas fecha o dialog
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar', style: TextStyle(color: widget.texto)),
        ),

        // Botão Salvar valida e chama a API
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.marrom,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            if (!(_formKey.currentState?.validate() ?? false)) {
              return;
            }

            try {
              await widget.authService.updateProfile({
                'newPassword': _senhaNovaController.text,
              });

              if (!mounted) return;

              Navigator.of(context).pop(); // Fecha o dialog após sucesso

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Senha alterada com sucesso!')),
              );
            } on AuthException catch (error) {
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(error.message)));
            } catch (error) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Erro ao conectar com a API.')),
              );
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
