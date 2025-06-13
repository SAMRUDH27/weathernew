import 'package:dio/dio.dart';
import '../models/news_model.dart';

class NewsService {
  // Using the provided NewsData.io API key
  static const String _apiKey = 'your api key';
  static const String _baseUrl = 'https://newsdata.io/api/1';

  final Dio _dio = Dio();

  Future<List<NewsArticle>> getTopHeadlines({String? category}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/news',
        queryParameters: {
          'country': 'us',
          'category': category ?? 'general',
          'apikey': _apiKey,
          'language': 'en',
          'page': 1,
        },
      );

      final List<dynamic> articles = response.data['results'] ?? [];
      return articles.map((json) => NewsArticle.fromNewsDataJson(json)).toList();
    } catch (e) {
      print('Error fetching top headlines: $e');
      return [];
    }
  }

  Future<List<NewsArticle>> searchNews(String query) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/news',
        queryParameters: {
          'q': query,
          'apikey': _apiKey,
          'language': 'en',
          'page': 1,
        },
      );

      final List<dynamic> articles = response.data['results'] ?? [];
      return articles.map((json) => NewsArticle.fromNewsDataJson(json)).toList();
    } catch (e) {
      print('Error searching news: $e');
      return [];
    }
  }
}
