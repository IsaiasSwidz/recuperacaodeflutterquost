import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  Future<Map<String, dynamic>> fetchSystemStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/todos/1'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load system status');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
  
  Future<void> sendAlert(String alertType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'alertType': alertType,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      
      if (response.statusCode != 201) {
        throw Exception('Failed to send alert');
      }
    } catch (e) {
      throw Exception('Failed to send alert: $e');
    }
  }
}