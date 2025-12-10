/// Serviço de API - Gerencia requisições HTTP para APIs externas
/// 
/// Esta classe fornece métodos para realizar requisições HTTP para APIs externas,
/// demonstrando a integração com serviços web, como parte dos requisitos do projeto
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Obtém dados de usuário da API pública
  /// 
  /// Faz uma requisição GET para obter informações de um usuário específico
  static Future<Map<String, dynamic>?> fetchUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Falha ao carregar usuário: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      return null;
    }
  }

  /// Cria um novo post na API pública (recurso de teste)
  /// 
  /// Faz uma requisição POST para criar um novo post na API
  static Future<Map<String, dynamic>?> createPost(String title, String body, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Falha ao criar post: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao criar post: $e');
      return null;
    }
  }

  /// Obtém posts da API pública
  /// 
  /// Faz uma requisição GET para obter uma lista de posts
  static Future<List<dynamic>?> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Falha ao carregar posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar posts: $e');
      return null;
    }
  }
}