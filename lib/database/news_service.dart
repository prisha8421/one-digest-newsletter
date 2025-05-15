import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:update_latest/models/news_article.dart'; // <-- Import the model

class NewsService {
  final List<String> defaultTopics = [
    'Technology',
    'Health',
    'Finance',
    'Politics',
    'Entertainment',
    'Sports',
    'Science',
    'Travel',
    'Education',
  ];

  Future<List<NewsArticle>> fetchLatestGeneralNews() async {
    final response = await http.post(
      Uri.parse('https://one-digest-newsletter.onrender.com/get-news'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'topics': defaultTopics}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
