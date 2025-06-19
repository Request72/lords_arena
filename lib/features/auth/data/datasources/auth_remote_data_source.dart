import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final String baseUrl = 'http://192.168.1.86:5000/api';

  Future<String?> signup(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return data['userId'];
      }
    } catch (e) {
      // ignore: avoid_print
      print('Signup error: $e');
    }
    return null;
  }

  Future<String?> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['userId'];
      }
    } catch (e) {
      // ignore: avoid_print
      print('Login error: $e');
    }
    return null;
  }
}
