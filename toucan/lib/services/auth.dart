import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://35.205.19.65:4000/';
  final String loginEndpoint = 'api/users/login';

  Future<String?> authenticate(String username, String password) async {
    final Map<String, String> data = {
      'name': username,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('$baseUrl$loginEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Store the JWT token
      final token = json.decode(response.body)['token'];
      await _saveToken(token);
      return token;
    } else {
      throw Exception('Authentication failed');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('jwt_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
