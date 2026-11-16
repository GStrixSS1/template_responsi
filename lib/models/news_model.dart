class NewsModel {
  final String id;
  final String title;
  final String description;
  final String pubDate;
  final String thumbnail;
  final String link;
  final String category;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.pubDate,
    required this.thumbnail,
    required this.link,
    required this.category,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json, {String? defaultCategory}) {
    final String cleanTitle = json['title'] ?? 'Kabar Berita';
    final String idVal = json['id']?.toString() ?? json['link']?.toString() ?? cleanTitle.hashCode.toString();

    String formattedDate = json['pubDate'] ?? json['published_at'] ?? 'Hari Ini';
    if (formattedDate.contains('T')) {
      formattedDate = formattedDate.split('T')[0];
    }

    return NewsModel(
      id: idVal,
      title: cleanTitle,
      description: json['description'] ?? json['summary'] ?? 'Ringkasan berita lengkap dapat diakses langsung pada portal informasi.',
      pubDate: formattedDate,
      thumbnail: json['thumbnail'] ?? json['image_url'] ?? json['image'] ?? '',
      link: json['link'] ?? json['url'] ?? '',
      category: json['category'] ?? defaultCategory ?? 'Nasional',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'pubDate': pubDate,
      'thumbnail': thumbnail,
      'link': link,
      'category': category,
    };
  }
}
