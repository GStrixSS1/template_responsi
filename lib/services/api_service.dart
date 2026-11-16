import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';
import '../models/category_model.dart';

class ApiService {
  static const String baseUrl = 'https://api-berita-indonesia.vercel.app/antara';

  static Future<List<NewsModel>> getNews({String? category, String? query}) async {
    final String activeCategory = (category != null && category.isNotEmpty && category.toLowerCase() != 'all')
        ? category.toLowerCase()
        : 'terbaru';

    final uri = Uri.parse('$baseUrl/$activeCategory/');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List? posts = data['data'] != null ? data['data']['posts'] : null;

      if (posts == null || posts.isEmpty) {
        return [];
      }

      List<NewsModel> newsList = posts.map((item) {
        return NewsModel.fromJson(item, defaultCategory: activeCategory.toUpperCase());
      }).toList();

      if (query != null && query.trim().isNotEmpty) {
        final q = query.toLowerCase().trim();
        newsList = newsList.where((n) => n.title.toLowerCase().contains(q) || n.description.toLowerCase().contains(q)).toList();
      }

      return newsList;
    } else {
      throw Exception('Gagal memuat portal berita (${response.statusCode})');
    }
  }

  static Future<List<CategoryModel>> getCategories() async {
    return [
      CategoryModel(slug: 'terbaru', name: 'Terbaru', iconName: 'newspaper'),
      CategoryModel(slug: 'politik', name: 'Politik', iconName: 'policy'),
      CategoryModel(slug: 'hukum', name: 'Hukum', iconName: 'gavel'),
      CategoryModel(slug: 'ekonomi', name: 'Ekonomi', iconName: 'trending_up'),
      CategoryModel(slug: 'olahraga', name: 'Olahraga', iconName: 'sports_soccer'),
      CategoryModel(slug: 'otomotif', name: 'Otomotif', iconName: 'directions_car'),
      CategoryModel(slug: 'hiburan', name: 'Hiburan', iconName: 'movie'),
    ];
  }
}
