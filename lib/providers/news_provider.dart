import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';
import '../services/storage_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _newsService = NewsService();
  final StorageService _storageService = StorageService();
  
  List<NewsArticle> _articles = [];
  List<NewsArticle> _searchResults = [];
  List<NewsArticle> _bookmarkedArticles = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'general';
  String _searchQuery = '';

  // Getters
  List<NewsArticle> get articles => _articles;
  List<NewsArticle> get searchResults => _searchResults;
  List<NewsArticle> get bookmarkedArticles => _bookmarkedArticles;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  final List<String> categories = [
    'general',
    'business',
    'technology',
    'sports',
    'entertainment',
    'health',
    'science'
  ];

  NewsProvider() {
    _loadCachedData();
    getTopHeadlines();
    _loadBookmarks();
  }

  void _loadCachedData() {
    _articles = _storageService.getCachedNews(_selectedCategory) ?? [];
    notifyListeners();
  }

  void _loadBookmarks() {
    _bookmarkedArticles = _storageService.getBookmarkedArticles();
    notifyListeners();
  }

  Future<void> getTopHeadlines({String? category}) async {
    _setLoading(true);
    _error = null;

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _articles = _storageService.getCachedNews(category ?? _selectedCategory) ?? [];
        if (_articles.isEmpty) {
          throw Exception('No internet connection and no cached data');
        }
      } else {
        _articles = await _newsService.getTopHeadlines(category: category);
        await _storageService.saveNews(_articles, category ?? _selectedCategory);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      _searchQuery = '';
      notifyListeners();
      return;
    }

    _searchQuery = query;
    _setLoading(true);
    _error = null;

    try {
      _searchResults = await _newsService.searchNews(query);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _loadCachedData();
    getTopHeadlines(category: category);
  }

  Future<void> toggleBookmark(NewsArticle article) async {
    if (isBookmarked(article.url)) {
      await _storageService.removeBookmark(article.url);
    } else {
      await _storageService.bookmarkArticle(article);
    }
    _loadBookmarks();
  }

  bool isBookmarked(String url) {
    return _storageService.isBookmarked(url);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}