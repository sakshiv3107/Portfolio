class Article {
  final String title;
  final String excerpt;
  final String datePublished;
  final String? url;
  final String? readingTimeMinutes;
  final bool isPlaceholder;

  const Article({
    required this.title,
    required this.excerpt,
    required this.datePublished,
    this.url,
    this.readingTimeMinutes,
    this.isPlaceholder = false,
  });
}
