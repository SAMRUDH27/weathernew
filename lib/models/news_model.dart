class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String source;
  final String category;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.source,
    required this.category,
  });

  // For News API format
  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toIso8601String()),
      source: json['source']['name'] ?? '',
      category: json['category'] ?? 'general',
    );
  }

  // For NewsData.io API format
  factory NewsArticle.fromNewsDataJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? json['content'] ?? '',
      url: json['link'] ?? '',
      urlToImage: json['image_url'] ?? '',
      publishedAt: DateTime.parse(json['pubDate'] ?? DateTime.now().toIso8601String()),
      source: json['source_id'] ?? 'Unknown',
      category: (json['category'] is List) 
          ? (json['category'] as List).first ?? 'general'
          : json['category'] ?? 'general',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toIso8601String(),
      'source': source,
      'category': category,
    };
  }
}