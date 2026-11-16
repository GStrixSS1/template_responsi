import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/category_model.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com/products';

  static Future<List<ProductModel>> getProducts({String? category, String? query}) async {
    Uri uri;
    if (query != null && query.trim().isNotEmpty) {
      uri = Uri.parse('$baseUrl/search?q=${Uri.encodeComponent(query.trim())}');
    } else if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
      uri = Uri.parse('$baseUrl/category/${Uri.encodeComponent(category.toLowerCase())}');
    } else {
      uri = Uri.parse('$baseUrl?limit=30');
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List productsData = data['products'] ?? [];
      return productsData.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat katalog produk (${response.statusCode})');
    }
  }

  static Future<ProductModel> getProductDetail(int id) async {
    final uri = Uri.parse('$baseUrl/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ProductModel.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail produk (${response.statusCode})');
    }
  }

  static Future<List<CategoryModel>> getCategories() async {
    final uri = Uri.parse('$baseUrl/categories');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      if (data is List) {
        return data.take(20).map((item) => CategoryModel.fromJson(item)).toList();
      }
      return [];
    } else {
      throw Exception('Gagal memuat daftar kategori (${response.statusCode})');
    }
  }
}
