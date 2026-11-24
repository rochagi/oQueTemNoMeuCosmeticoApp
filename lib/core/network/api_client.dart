import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../storage/settings_storage.dart';
import 'api_exceptions.dart';

class ApiClient {
  final http.Client _client;
  final SettingsStorage _storage;
  final Duration timeout;

  ApiClient({
    http.Client? client,
    SettingsStorage? storage,
    this.timeout = const Duration(seconds: 15),
  })  : _client = client ?? http.Client(),
        _storage = storage ?? SettingsStorage();

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final baseUrl = await _storage.getBaseUrl();
    final cleanBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final uri = Uri.parse('$cleanBase$cleanEndpoint');

    try {
      final response = await _client
          .post(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(data),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException catch (e) {
      throw NetworkException('Sem conexão com o servidor: ${e.message}');
    } on http.ClientException catch (e) {
      throw NetworkException('Erro de rede: ${e.message}');
    } on TimeoutException {
      throw NetworkException('Tempo limite excedido ao conectar com o servidor.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erro inesperado: $e');
    }
  }

  Future<dynamic> get(String endpoint, [Map<String, String>? queryParams]) async {
    final baseUrl = await _storage.getBaseUrl();
    final cleanBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    
    var uri = Uri.parse('$cleanBase$cleanEndpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    try {
      final response = await _client
          .get(
            uri,
            headers: {'Accept': 'application/json'},
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException catch (e) {
      throw NetworkException('Sem conexão com o servidor: ${e.message}');
    } on http.ClientException catch (e) {
      throw NetworkException('Erro de rede: ${e.message}');
    } on TimeoutException {
      throw NetworkException('Tempo limite excedido ao conectar com o servidor.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erro inesperado: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    String errorMessage = 'Erro ao processar requisição (${response.statusCode})';
    if (decoded is Map<String, dynamic> && decoded['message'] != null) {
      errorMessage = decoded['message'].toString();
    }

    if (response.statusCode >= 500) {
      throw ServerException(errorMessage, response.statusCode);
    }

    throw ApiException(errorMessage, response.statusCode);
  }
}
