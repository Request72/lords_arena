import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class PlayerApiService {
  final String baseUrl = 'http://localhost:5000/api/player';

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
