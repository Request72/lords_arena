import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:lords_arena/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final String baseUrl = 'http://localhost:5000/api/auth';

  Future<UserModel?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserModel.fromJson(json);
    } else {
      dev.log("Login failed", error: response.body);
      return null;
    }
  }

  Future<UserModel?> signup(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserModel.fromJson(json);
    } else {
      dev.log("Signup failed", error: response.body);
      return null;
    }
  }
}
