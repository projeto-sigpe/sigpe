import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigpe/service/token_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Testar se Salva, Recupera, Verifica e Remove o Token', () async {
    // 1. Simula a memória limpa do telemóvel/PC
    SharedPreferences.setMockInitialValues({});
    final tokenService = TokenService();

    // TESTE 1: Salvar e Recuperar (Continuar logado)
    await tokenService.saveToken('token_123');
    final tokenGuardado = await tokenService.getToken();
    print('Token recuperado: $tokenGuardado'); // Deve imprimir: token_123
    expect(tokenGuardado, 'token_123');

    // TESTE 2: Verificar se existe sessão
    final temSessao = await tokenService.hasToken();
    print('Tem sessão ativa? $temSessao'); // Deve imprimir: true
    expect(temSessao, isTrue);

    // TESTE 3: Sair (Remover Token)
    await tokenService.removeToken();
    final temSessaoAposLogout = await tokenService.hasToken();
    print('Tem sessão após logout? $temSessaoAposLogout'); // Deve imprimir: false
    expect(temSessaoAposLogout, isFalse);
  });
}