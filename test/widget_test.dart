import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sigpe/views/cadastro_page.dart';
import 'package:sigpe/views/login_page.dart';

void main() {
  testWidgets('login exibe mensagens para campos obrigatorios', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginPage()),
    );

    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(find.text('E-mail é obrigatório.'), findsOneWidget);
    expect(find.text('Senha é obrigatória.'), findsOneWidget);
    expect(find.text('Login realizado com sucesso!'), findsNothing);
  });

  testWidgets('login rejeita formato de e-mail invalido', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginPage()),
    );

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'email-invalido');
    await tester.enterText(campos.at(1), 'senha');
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(find.text('Digite um e-mail válido.'), findsOneWidget);
    expect(find.text('Login realizado com sucesso!'), findsNothing);
  });

  testWidgets('cadastro exibe mensagens para campos obrigatorios', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Cadastro()),
    );

    final botaoCadastrar = find.text('Cadastrar');
    await tester.ensureVisible(botaoCadastrar);
    await tester.tap(botaoCadastrar);
    await tester.pump();

    expect(find.text('Nome é obrigatório.'), findsOneWidget);
    expect(find.text('E-mail é obrigatório.'), findsOneWidget);
    expect(find.text('Senha é obrigatória.'), findsOneWidget);
    expect(find.text('Confirmação de senha é obrigatória.'), findsOneWidget);
    expect(find.text('Cadastro realizado com sucesso!'), findsNothing);
  });
}
