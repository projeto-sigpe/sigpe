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
    final userData = user is Map<String, dynamic> ? user : <String, dynamic>{};

    return AuthResponse(
      accessToken: _readString(json, ['access_token', 'accessToken', 'token']),
      refreshToken: _readString(json, ['refresh_token', 'refreshToken']),
      role: _readString(json, ['role']) ?? _readString(userData, ['role']),
      data: json,
    );
  }

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
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
  final TokenService _tokenService;

  AuthService({
    http.Client? client,
    TokenService? tokenService,
    this.baseUrl = ApiConfig.baseUrl,
  }) : _client = client ?? http.Client(),
       _tokenService = tokenService ?? TokenService();

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
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(ApiConfig.requestTimeout);

      final body = _decodeBody(response.body);

      // credenciais invÃƒÆ’Ã‚Â¡lidas
      if (response.statusCode == 401) {
        throw const AuthException(
          'e-mail ou senha invÃƒÆ’Ã‚Â¡lidos.',
          statusCode: 401,
        );
      }

      // acesso negado
      if (response.statusCode == 403) {
        throw const AuthException(
          'acesso negado para este usuario.',
          statusCode: 403,
        );
      }

      // login realizado com sucesso
      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(body);
        final accessToken = authResponse.accessToken;

        if (accessToken == null || accessToken.isEmpty) {
          throw const AuthException(
            'a api nao retornou o token de acesso esperado.',
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
            'nÃƒÆ’Ã‚Â£o foi possÃƒÆ’Ã‚Â­vel realizar o login.',
        statusCode: response.statusCode,
      );
    } on AuthException {
      rethrow;
    } on TimeoutException {
      throw const AuthException(
        'tempo limite de conexÃƒÆ’Ã‚Â£o excedido. tente novamente.',
      );
    } on http.ClientException {
      throw const AuthException(
        'nao foi possivel conectar ao servidor. verifique se a api esta funcionando.',
      );
    } on FormatException {
      throw const AuthException(
        'a resposta do servidor esta em um formato invalido.',
      );
    } catch (e) {
      debugPrint('erro interno durante o login: $e');

      throw const AuthException(
        'nao foi possivel concluir o login. verifique a conexao e tente novamente.',
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/register');

    try {
      final response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'nome': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(ApiConfig.requestTimeout);

      final body = _decodeBody(response.body);

      if (response.statusCode == 201) {
        return;
      }

      if (response.statusCode == 409) {
        throw const AuthException(
          'este e-mail ja esta cadastrado.',
          statusCode: 409,
        );
      }

      if (response.statusCode == 400) {
        throw AuthException(
          _messageFrom(body) ?? 'os dados do cadastro sao invalidos.',
          statusCode: 400,
        );
      }

      throw AuthException(
        _messageFrom(body) ?? 'nao foi possivel realizar o cadastro.',
        statusCode: response.statusCode,
      );
    } on AuthException {
      rethrow;
    } on TimeoutException {
      throw const AuthException(
        'tempo limite de conexÃƒÆ’Ã‚Â£o excedido. tente novamente.',
      );
    } on http.ClientException {
      throw const AuthException(
        'nÃƒÆ’Ã‚Â£o foi possÃƒÆ’Ã‚Â­vel conectar ao servidor. verifique se a api estÃƒÆ’Ã‚Â¡ funcionando.',
      );
    } on FormatException {
      throw const AuthException(
        'a resposta do servidor estÃƒÆ’Ã‚Â¡ em um formato invÃƒÆ’Ã‚Â¡lido.',
      );
    }
  }

  Future<List<Map<String, dynamic>>> getProfessores() async {
    final uri = Uri.parse('$baseUrl/api/admin/professores');

    try {
      final response = await _client
          .get(uri, headers: await getAuthHeaders())
          .timeout(ApiConfig.requestTimeout);
      final body = _decodeBody(response.body);

      if (response.statusCode == 200) {
        final professores = body['professores'];
        if (professores is List) {
          return professores
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        }
        throw const AuthException(
          'a API retornou uma lista de professores invÃƒÆ’Ã‚Â¡lida.',
        );
      }

      throw AuthException(
        _messageFrom(body) ??
            'nÃƒÆ’Ã‚Â£o foi possÃƒÆ’Ã‚Â­vel carregar os professores.',
        statusCode: response.statusCode,
      );
    } on AuthException {
      rethrow;
    } on TimeoutException {
      throw const AuthException(
        'tempo limite de conexÃƒÆ’Ã‚Â£o excedido. tente novamente.',
      );
    } on http.ClientException {
      throw const AuthException(
        'nÃƒÆ’Ã‚Â£o foi possÃƒÆ’Ã‚Â­vel conectar ao servidor. verifique se a API estÃƒÆ’Ã‚Â¡ funcionando.',
      );
    } on FormatException {
      throw const AuthException(
        'a resposta do servidor estÃƒÆ’Ã‚Â¡ em um formato invÃƒÆ’Ã‚Â¡lido.',
      );
    }
  }

  // CADASTRAR PROFESSOR (SOMENTE ADMINISTRADOR)
  Future<void> cadastrarProfessor({
    required String nome,
    required String email,
    required String password,
    required String matricula,
    required String departamento,
  }) async {
    final uri = Uri.parse('$baseUrl/api/admin/professores');

    try {
      final response = await _client
          .post(
            uri,
            headers: {
              ...await getAuthHeaders(),
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'nome': nome,
              'email': email,
              'password': password,
              'matricula': matricula,
              'departamento': departamento,
            }),
          )
          .timeout(ApiConfig.requestTimeout);

      final body = _decodeBody(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Professor cadastrado com sucesso.');
        return;
      }

      if (response.statusCode == 409) {
        throw const AuthException(
          'Este e-mail ou matrícula já está cadastrado.',
          statusCode: 409,
        );
      }

      throw AuthException(
        _messageFrom(body) ?? 'Não foi possível cadastrar o professor.',
        statusCode: response.statusCode,
      );
    } on AuthException {
      rethrow;
    } on TimeoutException {
      throw const AuthException('Tempo limite excedido. Tente novamente.');
    } on http.ClientException {
      throw const AuthException('Não foi possível conectar ao servidor.');
    } on FormatException {
      throw const AuthException(
        'A resposta do servidor está em formato inválido.',
      );
    }
  }

  Future<Map<String, dynamic>> getProfessorDetails(int professorId) async {
    final uri = Uri.parse('$baseUrl/api/admin/professores/$professorId');

    try {
      final response = await _client
          .get(uri, headers: await getAuthHeaders())
          .timeout(ApiConfig.requestTimeout);
      final body = _decodeBody(response.body);

      if (response.statusCode == 200) {
        final professor = body['professor'];
        final patrimonios = body['patrimonios'];

        if (professor is Map && patrimonios is List) {
          return {
            'professor': Map<String, dynamic>.from(professor),
            'patrimonios': patrimonios
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList(),
          };
        }
        throw const AuthException(
          'a API retornou os dados do professor em formato invÃ¡lido.',
        );
      }

      throw AuthException(
        _messageFrom(body) ??
            'nÃƒÆ’Ã‚Â£o foi possÃƒÆ’Ã‚Â­vel carregar o perfil do professor.',
        statusCode: response.statusCode,
      );
    } on AuthException {
      rethrow;
    } on TimeoutException {
      throw const AuthException(
        'tempo limite de conexÃƒÆ’Ã‚Â£o excedido. tente novamente.',
      );
    } on http.ClientException {
      throw const AuthException(
        'nÃƒÆ’Ã‚Â£o foi possÃƒÆ’Ã‚Â­vel conectar ao servidor. verifique se a API estÃƒÆ’Ã‚Â¡ funcionando.',
      );
    } on FormatException {
      throw const AuthException(
        'a resposta do servidor estÃƒÆ’Ã‚Â¡ em um formato invÃƒÆ’Ã‚Â¡lido.',
      );
    }
  }

 
Future<List<Map<String, dynamic>>> getPatrimonios({
  bool meus = false,
  String? status,
  String? categoria,
  String? busca,
}) async {
  final query = <String, String>{
    if (status != null && status.isNotEmpty) 'status': status,
    if (categoria != null && categoria.isNotEmpty)
      'categoria': categoria,
    if (busca != null && busca.isNotEmpty) 'busca': busca,
  };

  final path = meus
      ? '/api/patrimonios/meus'
      : '/api/patrimonios';

  final uri = Uri.parse('$baseUrl$path').replace(
    queryParameters: query.isEmpty ? null : query,
  );

  final response = await _client
      .get(uri, headers: await getAuthHeaders())
      .timeout(ApiConfig.requestTimeout);

  debugPrint('SIGPE: GET $uri');
  debugPrint('SIGPE: status HTTP ${response.statusCode}');
  debugPrint('SIGPE: resposta dos patrimônios: ${response.body}');

  final decoded = _decodeBody(response.body);

  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw AuthException(
      _messageFrom(decoded) ??
          'Não foi possível carregar os patrimônios.',
      statusCode: response.statusCode,
    );
  }

  // A API pode retornar a lista diretamente ou dentro de um objeto.
  dynamic procurarLista(dynamic valor, [int nivel = 0]) {
    if (valor is List) {
      return valor;
    }

    if (valor is! Map || nivel >= 5) {
      return null;
    }

    // Formatos de resposta aceitos.
    for (final chave in [
      'patrimonios',
      'patrimônios',
      'data',
      'items',
      'results',
      'content',
    ]) {
      if (valor.containsKey(chave)) {
        final resultado = procurarLista(
          valor[chave],
          nivel + 1,
        );

        if (resultado != null) {
          return resultado;
        }
      }
    }

    return null;
  }

  final lista = procurarLista(decoded);

  if (lista == null) {
    throw AuthException(
      'A resposta da API não contém uma lista de patrimônios. '
      'Confira o JSON exibido no console.',
    );
  }

  return lista.map<Map<String, dynamic>>((item) {
    if (item is Map) {
      return Map<String, dynamic>.from(item);
    }

    throw const AuthException(
      'A API retornou um patrimônio em formato inválido.',
    );
  }).toList();
}


  Future<void> createPatrimonio(Map<String, dynamic> data) async =>
      _sendJson(Uri.parse('$baseUrl/api/patrimonios'), data);
  Future<void> assignPatrimonio(
    int id, {
    required int professorId,
    String? observacoes,
  }) async =>
      _sendJson(Uri.parse('$baseUrl/api/admin/patrimonios/$id/atribuir'), {
        'professorId': professorId,
        if (observacoes?.isNotEmpty ?? false) 'observacoes': observacoes,
      });
  Future<void> unassignPatrimonio(int id, {String? motivo}) async => _sendJson(
    Uri.parse('$baseUrl/api/admin/patrimonios/$id/desatribuir'),
    {if (motivo?.isNotEmpty ?? false) 'motivo': motivo},
  );
  
Future<List<Map<String, dynamic>>> getPatrimonioHistory(int id) async {
  final uri = Uri.parse(
    '$baseUrl/api/admin/patrimonios/$id/historico',
  );

  try {
    final response = await _client
        .get(uri, headers: await getAuthHeaders())
        .timeout(ApiConfig.requestTimeout);

    debugPrint('SIGPE: GET $uri');
    debugPrint('SIGPE: histórico HTTP ${response.statusCode}');
    debugPrint('SIGPE: resposta do histórico: ${response.body}');

    final body = _decodeBody(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthException(
        _messageFrom(body) ??
            'Não foi possível carregar o histórico do patrimônio.',
        statusCode: response.statusCode,
      );
    }

    final lista = _procurarListaHistorico(body);

    if (lista == null) {
      throw const AuthException(
        'A API não retornou uma lista de movimentações. '
        'Confira a resposta do histórico no console.',
      );
    }

    return lista.map<Map<String, dynamic>>((item) {
      if (item is Map) {
        return Map<String, dynamic>.from(item);
      }

      throw const AuthException(
        'A API retornou uma movimentação em formato inválido.',
      );
    }).toList();
  } on AuthException {
    rethrow;
  } on TimeoutException {
    throw const AuthException(
      'Tempo limite excedido ao carregar o histórico.',
    );
  } on http.ClientException {
    throw const AuthException(
      'Não foi possível conectar à API para carregar o histórico.',
    );
  } on FormatException {
    throw const AuthException(
      'A API retornou um JSON inválido no histórico.',
    );
  }
}

dynamic _procurarListaHistorico(dynamic valor, [int nivel = 0]) {
  if (valor is List) {
    return valor;
  }

  if (valor is! Map || nivel >= 5) {
    return null;
  }

  for (final chave in [
    'historico',
    'histórico',
    'movimentacoes',
    'movimentações',
    'history',
    'data',
    'items',
    'results',
    'content',
  ]) {
    if (valor.containsKey(chave)) {
      final resultado = _procurarListaHistorico(
        valor[chave],
        nivel + 1,
      );

      if (resultado != null) {
        return resultado;
      }
    }
  }

  return null;
}

  Future<Map<String, dynamic>> getProfile() =>
      _getJson(Uri.parse('$baseUrl/api/profile'));
  Future<Map<String, dynamic>> getPatrimonioStats() =>
      _getJson(Uri.parse('$baseUrl/api/admin/patrimonios/stats'));
  Future<void> updateProfile(Map<String, dynamic> data) async =>
      _sendJson(Uri.parse('$baseUrl/api/profile'), data, method: 'PUT');
  Future<void> forgotPassword(String email) async => _sendJson(
    Uri.parse('$baseUrl/api/auth/forgot-password'),
    {'email': email},
    authenticated: false,
  );
  Future<void> verifyCode({
    required String email,
    required String code,
  }) async => _sendJson(Uri.parse('$baseUrl/api/auth/verify-code'), {
    'email': email,
    'code': code,
  }, authenticated: false);
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async => _sendJson(Uri.parse('$baseUrl/api/auth/reset-password'), {
    'email': email,
    'code': code,
    'newPassword': newPassword,
  }, authenticated: false);
  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final response = await _client
        .get(uri, headers: await getAuthHeaders())
        .timeout(ApiConfig.requestTimeout);
    return _handleJsonResponse(response);
  }

  Future<Map<String, dynamic>> _sendJson(
    Uri uri,
    Map<String, dynamic> data, {
    String method = 'POST',
    bool authenticated = true,
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (authenticated) headers.addAll(await getAuthHeaders());
    final response = method == 'PUT'
        ? await _client.put(uri, headers: headers, body: jsonEncode(data))
        : await _client.post(uri, headers: headers, body: jsonEncode(data));
    return _handleJsonResponse(response);
  }

  Map<String, dynamic> _handleJsonResponse(http.Response response) {
    final body = _decodeBody(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) return body;
    throw AuthException(
      _messageFrom(body) ?? 'a API recusou a operaÃƒÂ§ÃƒÂ£o.',
      statusCode: response.statusCode,
    );
  }

  // RECUPERAR TOKEN
  Future<String?> getToken() async {
    return _tokenService.getToken();
  }

  // VERIFICAR SE EXISTE UMA SESSÃƒÆ’Ã†â€™O
  Future<bool> hasSession() async {
    return _tokenService.hasToken();
  }

  // RECUPERAR REFRESH TOKEN
  Future<String?> getRefreshToken() async {
    return _tokenService.getRefreshToken();
  }

  // ENCERRAR SESSÃƒÆ’Ã†â€™O
  Future<void> logout() async {
    await _tokenService.removeToken();
    await _tokenService.removeRefreshToken();

    debugPrint('logout: tokens removidos.');
  }

  // CABEÃƒÆ’Ã¢â‚¬Â¡ALHOS PARA REQUISIÃƒÆ’Ã¢â‚¬Â¡ÃƒÆ’Ã¢â‚¬Â¢ES AUTENTICADAS
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _tokenService.getToken();

    if (token == null || token.trim().isEmpty) {
      throw const AuthException(
        'sessÃƒÆ’Ã‚Â£o nÃƒÆ’Ã‚Â£o encontrada. faÃƒÆ’Ã‚Â§a login novamente.',
      );
    }

    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
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
      return {...decoded, ...nestedData};
    }

    return decoded;
  }

  // LER A MENSAGEM DE ERRO DA API
  String? _messageFrom(Map<String, dynamic> body) {
    final message = body['message'] ?? body['error'];

    return message is String && message.trim().isNotEmpty ? message : null;
  }

  // LIBERAR O CLIENTE HTTP
  void dispose() {
    _client.close();
  }
}
