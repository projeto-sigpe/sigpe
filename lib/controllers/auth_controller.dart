import 'package:flutter/foundation.dart';
import '../service/service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  String? _userRole;

  AuthController({AuthService? authService})
      : _authService = authService ?? AuthService();

  // --- GETTERS PARA A TELA (UI) ---
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  String? get userRole => _userRole;

  /// 1. VERIFICAR SESSÃO INICIAL
  /// Chama o AuthService para saber se o utilizador já tem token salvo ao abrir o app.
  Future<bool> checkAuthStatus() async {
    _setLoading(true);
    try {
      final hasSession = await _authService.hasSession();
      _isAuthenticated = hasSession;
      return hasSession;
    } catch (e) {
      _isAuthenticated = false;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 2. REALIZAR LOGIN
  /// Recebe e-mail e senha da tela de login, executa a requisição no AuthService
  /// e o token é automaticamente guardado pelo AuthService/TokenService.
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      _isAuthenticated = true;
      _userRole = response.role;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Ocorreu um erro inesperado. Tente novamente.';
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 3. FAZER LOGOUT
  /// Remove os tokens salvos no dispositivo e reseta o estado da sessão.
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _isAuthenticated = false;
      _userRole = null;
      _errorMessage = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Limpa mensagens de erro exibidas na tela
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}