import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> predictYarn({
    required double gsm,
    required double cotton,
    required double polyester,
    required double elastane,
  }) async {
    final url = Uri.parse('$baseUrl/predict/');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "gsm": gsm,
        "cotton": cotton,
        "polyester": polyester,
        "elastane": elastane,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch predictions: ${response.body}');
    }
  }
}
