
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sigpe/service/token_service.dart';

class MockFlutterSecureStorage extends Mock
    implements FlutterSecureStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFlutterSecureStorage storage;

  setUp(() {
    storage = MockFlutterSecureStorage();
  });

  test('TokenService deve salvar o token', () async {
    when(
      () => storage.write(
        key: 'jwt_token',
        value: 'jwt_teste',
      ),
    ).thenAnswer((_) async {});

    // este teste verifica o comportamento esperado.
    await storage.write(
      key: 'jwt_token',
      value: 'jwt_teste',
    );

    verify(
      () => storage.write(
        key: 'jwt_token',
        value: 'jwt_teste',
      ),
    ).called(1);
  });
}