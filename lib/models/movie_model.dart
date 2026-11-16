class MovieModel {
  final int id;
  final String title;
  final String status;
  final String genre;
  final String rating;
  final String premiered;
  final String synopsis;
  final String image;

  MovieModel({
    required this.id,
    required this.title,
    required this.status,
    required this.genre,
    required this.rating,
    required this.premiered,
    required this.synopsis,
    required this.image,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    String cleanSynopsis = '';
    if (json['summary'] != null) {
      cleanSynopsis = json['summary'].toString().replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
    }

    String ratingVal = 'N/A';
    if (json['rating'] is Map && json['rating']['average'] != null) {
      ratingVal = json['rating']['average'].toString();
    } else if (json['rating'] != null) {
      ratingVal = json['rating'].toString();
    }

    String genreVal = 'Movie';
    if (json['genres'] is List && (json['genres'] as List).isNotEmpty) {
      genreVal = (json['genres'] as List).join(', ');
    } else if (json['genre'] != null) {
      genreVal = json['genre'].toString();
    }

    String imageUrl = '';
    if (json['image'] is Map) {
      imageUrl = json['image']['original'] ?? json['image']['medium'] ?? '';
    } else if (json['image'] != null) {
      imageUrl = json['image'].toString();
    }

    return MovieModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['name'] ?? json['title'] ?? 'Untitled',
      status: json['status'] ?? 'Running',
      genre: genreVal,
      rating: ratingVal,
      premiered: json['premiered'] ?? json['release_date'] ?? '-',
      synopsis: cleanSynopsis.isNotEmpty ? cleanSynopsis : 'Tidak ada sinopsis tersedia.',
      image: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'genre': genre,
      'rating': rating,
      'premiered': premiered,
      'summary': synopsis,
      'image': image,
    };
  }
}

