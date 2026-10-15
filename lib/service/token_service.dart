
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const String _tokenKey = 'jwt_token';

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  /// salva o token jwt
  Future<void> saveToken(String token) async {
    if (token.trim().isEmpty) {
      throw ArgumentError('o token não pode estar vazio.');
    }

    await _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  /// recupera o token jwt
  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  /// verifica se existe um token salvo
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.trim().isNotEmpty;
  }

  /// remove o token no logout
  Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
