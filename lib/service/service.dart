
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
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

      if (value is String && value.trim().isNotEmpty) {
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

      // credenciais inválidas
      if (response.statusCode == 401) {
        throw const AuthException(
          'e-mail ou senha inválidos.',
          statusCode: 401,
        );
      }

      // acesso negado
      if (response.statusCode == 403) {
        throw const AuthException(
          'acesso negado para este usuário.',
          statusCode: 403,
        );
      }

      // login realizado
      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(body);
        final accessToken = authResponse.accessToken;

        if (accessToken == null || accessToken.isEmpty) {
          throw const AuthException(
            'a api não retornou o token de acesso esperado.',
          );
        }

        await _tokenService.saveToken(accessToken);

        debugPrint('login: token de acesso salvo com sucesso.');

        final refreshToken = authResponse.refreshToken;

        if (refreshToken != null && refreshToken.isNotEmpty) {
          await _tokenService.saveRefreshToken(refreshToken);
          debugPrint('login: refresh token salvo com sucesso.');
        }

        return authResponse;
      }

      throw AuthException(
        _messageFrom(body) ??
            'não foi possível realizar o login.',
        statusCode: response.statusCode,
      );
    } on AuthException {
      rethrow;
    } on TimeoutException {
      throw const AuthException(
        'tempo limite de conexão excedido. tente novamente.',
      );
    } on http.ClientException {
      throw const AuthException(
        'não foi possível conectar ao servidor. '
        'verifique se a api está funcionando.',
      );
    } on FormatException {
      throw const AuthException(
        'a resposta do servidor está em um formato inválido.',
      );
    } catch (e) {
      debugPrint('erro interno durante o login: $e');

      throw const AuthException(
        'não foi possível concluir o login. '
        'verifique a conexão e tente novamente.',
      );
    }
  }

  // RECUPERAR TOKEN
  Future<String?> getToken() async {
    return _tokenService.getToken();
  }

  // VERIFICAR SE EXISTE UMA SESSÃO
  Future<bool> hasSession() async {
    return _tokenService.hasToken();
  }

  // RECUPERAR REFRESH TOKEN
  Future<String?> getRefreshToken() async {
    return _tokenService.getRefreshToken();
  }

  // ENCERRAR SESSÃO
  Future<void> logout() async {
    await _tokenService.removeToken();
    await _tokenService.removeRefreshToken();

    debugPrint('logout: tokens removidos.');
  }

  // CABEÇALHOS PARA REQUISIÇÕES AUTENTICADAS
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _tokenService.getToken();

    if (token == null || token.trim().isEmpty) {
      throw const AuthException(
        'sessão não encontrada. faça login novamente.',
      );
    }

    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // CONVERTER A RESPOSTA DA API EM JSON
  Map<String, dynamic> _decodeBody(String body) {
    if (body.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(body);

    if (decoded is! Map<String, dynamic>) {
      return <String, dynamic>{};
    }

    final nestedData = decoded['data'];

    if (nestedData is Map<String, dynamic>) {
      return {
        ...decoded,
        ...nestedData,
      };
    }

    return decoded;
  }

  // LER A MENSAGEM DE ERRO DA API
  String? _messageFrom(Map<String, dynamic> body) {
    final message = body['message'] ?? body['error'];

    return message is String && message.trim().isNotEmpty
        ? message
        : null;
  }

  // LIBERAR O CLIENTE HTTP
  void dispose() {
    _client.close();
  }
}
