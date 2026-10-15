
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'jwt_token';

  // Salva o JWT
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Recupera o JWT
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Verifica se existe um token salvo
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearTokens() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.remove('jwt_token');
  await prefs.remove('refresh_token');
}

  // Remove o JWT no logout
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }


static const String _refreshTokenKey = 'refresh_token';

Future<void> saveRefreshToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_refreshTokenKey, token);
}

Future<String?> getRefreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_refreshTokenKey);
}

Future<void> removeRefreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_refreshTokenKey);
}
}
