import 'package:flutter/material.dart';
import 'package:sigpe/views/cadastro_page.dart';
import 'package:sigpe/views/dashboard.dart';
import 'package:sigpe/views/dashboard_professor.dart';
import 'package:sigpe/views/home.dart';
import 'package:sigpe/views/login_page.dart';
import 'package:sigpe/views/nova_senha.dart';
import 'package:sigpe/views/recuperacao_senha.dart';
import 'package:sigpe/views/verificar_codigo.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const cadastro = '/cadastro';
  static const recuperarSenha = '/recuperar-senha';
  static const verificarCodigo = '/verificar-codigo';
  static const novaSenha = '/nova-senha';
  static const admin = '/admin';
  static const professor = '/professor';

  static Map<String, WidgetBuilder> get routes => {
        home: (_) => const Home(),
        login: (_) => const LoginPage(),
        cadastro: (_) => const Cadastro(),
        recuperarSenha: (_) => const RecuperarSenhaPage(),
        verificarCodigo: (_) => const VerificarCodigoPage(),
        novaSenha: (_) => const NovaSenhaPage(),
        admin: (_) => const Dashboard(),
        professor: (_) => const DashboardProfessorPage(),
      };
}
