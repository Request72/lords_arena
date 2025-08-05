import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class PlayerApiService {
  late final String baseUrl;

  PlayerApiService() {
    if (kIsWeb) {
      baseUrl = 'http://localhost:5000/api/player';
    } else if (Platform.isAndroid) {
      baseUrl = 'http://localhost:5000/api/player';
    } else {
      baseUrl = 'http://localhost:5000/api/player';
    }
  }

  Future<void> sendPlayerMovement(String userId, double x, double y) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/move'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'x': x, 'y': y}),
      );

      if (response.statusCode == 200) {
        logger.i('✅ Player movement sent successfully: ($x, $y)');
      } else {
        logger.w(
          '⚠️ Failed to send player movement: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      logger.e('❌ Error sending player movement: $e');
    }
  }
}
