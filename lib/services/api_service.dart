import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://192.168.1.223:4000"; // IP base del servidor

  Future<Map<String, dynamic>> registerUser(
      String name, String email, String password, String fandoms) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "fandoms": fandoms,
      }),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchFandoms() async {
    final response = await http.get(Uri.parse('$baseUrl/auth/fandoms')); // Prefijo 'auth'

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener los fandoms');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {"success": true, "data": jsonDecode(response.body)};
    } else {
      return {"success": false, "error": jsonDecode(response.body)['error']};
    }
  }
}
