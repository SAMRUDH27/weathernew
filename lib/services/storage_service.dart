import 'package:hive/hive.dart';
import '../models/weather_model.dart';
import '../models/news_model.dart';

class StorageService {
  static const String _weatherBox = 'weather';
  static const String _newsBox = 'news';
  static const String _bookmarksBox = 'bookmarks';
  static const String _settingsBox = 'settings';

  // Weather Storage
  Future<void> saveWeather(Weather weather) async {
    final box = Hive.box(_weatherBox);
    await box.put('current_weather', weather.toJson());
  }

  Weather? getCachedWeather() {
    final box = Hive.box(_weatherBox);
    final data = box.get('current_weather');
    if (data != null && data is Map) {
      try {
        return Weather.fromJson(Map<String, dynamic>.from(data));
      } catch (e) {
        print('Error parsing weather data: $e');
      }
    }
    return null;
  }

  // News Storage
  Future<void> saveNews(List<NewsArticle> articles, String category) async {
    final box = Hive.box(_newsBox);
    final data = articles.map((article) => article.toJson()).toList();
    await box.put('news_$category', data);
  }

  List<NewsArticle>? getCachedNews(String category) {
    final box = Hive.box(_newsBox);
    final data = box.get('news_$category');
    if (data != null && data is List) {
      try {
        return data
            .map((json) => NewsArticle.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      } catch (e) {
        print('Error parsing cached news: $e');
      }
    }
    return null;
  }

  // Bookmarks
  Future<void> bookmarkArticle(NewsArticle article) async {
    final box = Hive.box(_bookmarksBox);
    final bookmarks = getBookmarkedArticles();
    bookmarks.add(article);
    await box.put('bookmarks', bookmarks.map((a) => a.toJson()).toList());
  }

  Future<void> removeBookmark(String url) async {
    final box = Hive.box(_bookmarksBox);
    final bookmarks = getBookmarkedArticles();
    bookmarks.removeWhere((article) => article.url == url);
    await box.put('bookmarks', bookmarks.map((a) => a.toJson()).toList());
  }

  List<NewsArticle> getBookmarkedArticles() {
    final box = Hive.box(_bookmarksBox);
    final data = box.get('bookmarks');
    if (data != null && data is List) {
      try {
        return data
            .map((json) => NewsArticle.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      } catch (e) {
        print('Error parsing bookmarks: $e');
      }
    }
    return [];
  }

  bool isBookmarked(String url) {
    return getBookmarkedArticles().any((article) => article.url == url);
  }

  // Settings
  Future<void> saveThemeMode(String themeMode) async {
    final box = Hive.box(_settingsBox);
    await box.put('theme_mode', themeMode);
  }

  String getThemeMode() {
    final box = Hive.box(_settingsBox);
    return box.get('theme_mode', defaultValue: 'system');
  }
}
