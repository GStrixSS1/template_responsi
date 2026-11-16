import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';
import '../models/category_model.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<MealModel>> getMeals({String? category, String? query}) async {
    Uri uri;
    if (query != null && query.trim().isNotEmpty) {
      uri = Uri.parse('$baseUrl/search.php?s=${Uri.encodeComponent(query.trim())}');
    } else if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
      uri = Uri.parse('$baseUrl/filter.php?c=${Uri.encodeComponent(category)}');
    } else {
      uri = Uri.parse('$baseUrl/search.php?s=');
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List? mealsData = data['meals'];
      if (mealsData == null) {
        return [];
      }
      return mealsData.map((item) => MealModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat menu restoran (${response.statusCode})');
    }
  }

  static Future<MealModel> getMealDetail(String id) async {
    final uri = Uri.parse('$baseUrl/lookup.php?i=$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List? mealsData = data['meals'];
      if (mealsData != null && mealsData.isNotEmpty) {
        return MealModel.fromJson(mealsData.first);
      }
      throw Exception('Menu tidak ditemukan');
    } else {
      throw Exception('Gagal memuat detail menu (${response.statusCode})');
    }
  }

  static Future<List<CategoryModel>> getCategories() async {
    final uri = Uri.parse('$baseUrl/categories.php');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List? categoriesData = data['categories'];
      if (categoriesData == null) {
        return [];
      }
      return categoriesData.map((item) => CategoryModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat daftar kategori (${response.statusCode})');
    }
  }
}

