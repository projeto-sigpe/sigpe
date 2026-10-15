import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'token_service.dart';

class ApiConfig {
  static const String baseUrl = 'http://localhost:8081';
  static const Duration requestTimeout = Duration(seconds: 15);
}

class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final String? role;
  final Map<String, dynamic> data;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final userData = user is Map<String, dynamic>
        ? user
        : const <String, dynamic>{};

    return AuthResponse(
      accessToken: _readString(json, const [
        'access_token',
        'accessToken',
        'token',
      ]),
      refreshToken: _readString(json, const [
        'refresh_token',
        'refreshToken',
      ]),
      role: _readString(json, const [
            'role',
          ]) ??
          _readString(userData, const ['role']),
      data: json,
    );
  }

  static String? _readString(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];

      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    return null;
  }
}

class AuthException implements Exception {
  final int? statusCode;
  final String message;

  const AuthException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class AuthService {
  final http.Client _client;
  final String baseUrl;

  final TokenService _tokenService = TokenService();

  AuthService({
    http.Client? client,
    this.baseUrl = ApiConfig.baseUrl,
  }) : _client = client ?? http.Client();

  // LOGIN: autentica e salva os tokens
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/login');

    try {
      final response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(ApiConfig.requestTimeout);

      final body = _decodeBody(response.body);

      switch (response.statusCode) {
        case 200:
          final authResponse = AuthResponse.fromJson(body);

          // Salva o JWT quando a API retornar o token
          final accessToken = authResponse.accessToken;

          if (accessToken != null && accessToken.isNotEmpty) {
            await _tokenService.saveToken(accessToken);
          }

          // Salva o refresh token, se a API fornecer
          final refreshToken = authResponse.refreshToken;

          if (refreshToken != null && refreshToken.isNotEmpty) {
            await _tokenService.saveRefreshToken(refreshToken);
          }

          return authResponse;

        case 401:
          throw const AuthException(
            'E-mail ou senha inválidos.',
            statusCode: 401,
          );

        case 403:
          throw const AuthException(
            'Acesso negado para este usuário.',
            statusCode: 403,
          );

        default:
          throw AuthException(
            _messageFrom(body) ??
                'Não foi possível realizar o login.',
            statusCode: response.statusCode,
          );
      }
    } on AuthException {
      rethrow;
    } on TimeoutException {
      throw const AuthException(
        'A conexão com o servidor expirou.',
      );
    } on http.ClientException {
      throw const AuthException(
        'Não foi possível conectar ao servidor. '
        'Verifique a API e sua rede.',
      );
    } catch (_) {
      throw const AuthException(
        'Não foi possível concluir o login. '
        'Verifique a conexão e tente novamente.',
      );
    }
  }

  // Recupera o JWT salvo
  Future<String?> getToken() async {
    return _tokenService.getToken();
  }

  // Verifica se existe um JWT salvo
  Future<bool> hasSession() async {
    return _tokenService.hasToken();
  }

  // Encerra a sessão local e remove os tokens
  Future<void> logout() async {
    await _tokenService.removeToken();
    await _tokenService.removeRefreshToken();
  }

  // Fecha o cliente HTTP quando não for mais necessário
  void dispose() {
    _client.close();
  }

  Map<String, dynamic> _decodeBody(String body) {
    if (body.trim().isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(body);

      return decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{};
    } on FormatException {
      return <String, dynamic>{};
    }
  }

  String? _messageFrom(Map<String, dynamic> body) {
    final message = body['message'] ?? body['error'];

    return message is String && message.isNotEmpty
        ? message
        : null;
  }
}