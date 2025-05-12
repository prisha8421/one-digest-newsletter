import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  Future<List<dynamic>> fetchNewsForTopics(List<String> topics) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/get-news'), // or hosted URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'topics': topics}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
