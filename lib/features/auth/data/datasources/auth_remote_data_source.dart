import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:lords_arena/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  late final String baseUrl;

  AuthRemoteDataSource() {
    if (kIsWeb) {
      baseUrl = 'http://localhost:5000/api/auth'; // ✅ Web uses localhost
    } else if (Platform.isAndroid) {
      baseUrl = 'http://192.168.118.207:5000/api/auth'; // ✅ Android emulator
    } else {
      baseUrl = 'http://localhost:5000/api/auth'; // ✅ iOS/desktop
    }
  }

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
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      dev.log("Signup response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return UserModel.fromJson(json);
      } else {
        dev.log("Signup failed", error: response.body);
        return null;
      }
    } catch (e, stack) {
      dev.log("Signup error", error: e, stackTrace: stack);
      return null;
    }
  }
}
