import '../service/token_service.dart';

class AuthController {
  final TokenService _tokenService = TokenService();

  Future<void> login(String token) async {
    await _tokenService.saveToken(token);
  }

  Future<bool> isLoggedIn() async {
    return await _tokenService.hasToken();
  }

  Future<String?> getToken() async {
    return await _tokenService.getToken();
  }

  Future<void> logout() async {
    await _tokenService.removeToken();
  }
}