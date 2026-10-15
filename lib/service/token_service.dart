
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  static const String _tokenKey = 'jwt_token';
  static const String _refreshTokenKey = 'refresh_token';

  // salvar o jwt principal
  Future<void> saveToken(String token) async {
    if (token.trim().isEmpty) {
      throw ArgumentError('o token não pode estar vazio.');
    }

    await _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  // recuperar o jwt principal
  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  // verificar se existe um jwt salvo
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.trim().isNotEmpty;
  }

  // remover o jwt principal
  Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // salvar o refresh token
  Future<void> saveRefreshToken(String token) async {
    if (token.trim().isEmpty) {
      throw ArgumentError('o refresh token não pode estar vazio.');
    }

    await _storage.write(
      key: _refreshTokenKey,
      value: token,
    );
  }

  // recuperar o refresh token
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  // remover o refresh token
  Future<void> removeRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }
}
