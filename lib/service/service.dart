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
        : <String, dynamic>{};

    return AuthResponse(
      accessToken: _readString(json, [
        'access_token',
        'accessToken',
        'token',
      ]),
      refreshToken: _readString(json, [
        'refresh_token',
        'refreshToken',
      ]),
      role: _readString(json, ['role']) ??
          _readString(userData, ['role']),
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

  // LOGIN
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

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(body);

        final accessToken = authResponse.accessToken;

        if (accessToken == null || accessToken.isEmpty) {
          throw const AuthException(
            'Login realizado, mas a API não retornou o JWT esperado.',
          );
        }

        await _tokenService.saveToken(accessToken);

        final refreshToken = authResponse.refreshToken;

        if (refreshToken != null && refreshToken.isNotEmpty) {
          await _tokenService.saveRefreshToken(refreshToken);
        }

        return authResponse;
      }

      if (response.statusCode == 401) {
        throw const AuthException(
          'E-mail ou senha inválidos.',
          statusCode: 401,
        );
      }

      if (response.statusCode == 403) {
        throw const AuthException(
          'Acesso negado para este usuário.',
          statusCode: 403,
        );
      }

      throw AuthException(
        _messageFrom(body) ?? 'Não foi possível realizar o login.',
        statusCode: response.statusCode,
      );
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
    } on FormatException {
      throw const AuthException(
        'A resposta do servidor está em um formato inválido.',
      );
    } catch (_) {
      throw const AuthException(
        'Não foi possível concluir o login. '
        'Verifique a conexão e tente novamente.',
      );
    }
  }

  // RECUPERAR JWT
  Future<String?> getToken() async {
    return _tokenService.getToken();
  }

  // VERIFICAR SESSÃO LOCAL
  Future<bool> hasSession() async {
    return _tokenService.hasToken();
  }

  // RECUPERAR REFRESH TOKEN
  Future<String?> getRefreshToken() async {
    return _tokenService.getRefreshToken();
  }

  // LOGOUT
  Future<void> logout() async {
    await _tokenService.removeToken();
    await _tokenService.removeRefreshToken();
  }

  // REQUISIÇÕES AUTENTICADAS
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _tokenService.getToken();

    if (token == null || token.isEmpty) {
      throw const AuthException(
        'Sessão não encontrada. Faça login novamente.',
      );
    }

    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _decodeBody(String body) {
    if (body.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(body);

    if (decoded is Map<String, dynamic>) {
      // Aceita também respostas com os dados dentro de "data".
      final nestedData = decoded['data'];

      if (nestedData is Map<String, dynamic> &&
          decoded['access_token'] == null &&
          decoded['accessToken'] == null &&
          decoded['token'] == null) {
        return {
          ...nestedData,
          if (decoded['message'] != null)
            'message': decoded['message'],
        };
      }

      return decoded;
    }

    return <String, dynamic>{};
  }

  String? _messageFrom(Map<String, dynamic> body) {
    final message = body['message'] ?? body['error'];

    return message is String && message.isNotEmpty
        ? message
        : null;
  }

  void dispose() {
    _client.close();
  }
}